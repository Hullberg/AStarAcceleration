
#ifndef MEMORYCONTROLLERPRO_H_
#define MEMORYCONTROLLERPRO_H_

#include "ManagerSync.h"
#include "MappedElements.h"			// defines MappedRegisterPtr
#include "MemoryControllerStreams.h"
#include "MemoryControllerConfig.h"
#include "MemoryControllerRAM.h"
#include <memory>
#include <vector>
#include <deque>

namespace maxcompilersim {

/*
 * A MemoryControlGroup represents one input command channel and several input/output
 * streams. MemoryControlGroup objects are created by the MemoryController when calling
 * the addMemoryControlGroup method.
 *
 */

class MemoryControlGroup
{
private:
	FifoConfig m_data_fifo_config;
	FifoConfig m_command_fifo_config;
	FifoConfig m_echo_fifo_config;
	int m_group_number;
	std::string m_control_group_name;

	FifoCommandStreamPtr m_command_input_buffer;
	FifoCommandEchoStreamPtr m_command_echo_buffer;
	std::vector<FifoOutputStreamPtr> m_output_buffers;
	std::vector<FifoInputStreamPtr> m_input_buffers;

protected:
	// the following methods are only to be called by the memory manager
	friend class MemoryControllerPro;
	MemoryControlGroup(
			std::string name,
			int group_number,
			const FifoConfig &data_fifo_config,
			const FifoConfig &command_fifo_config,
			const FifoConfig &echo_fifo_config);

	const std::string getInternalCommandStreamName() const;
	void reset();

public:
	// constructor protected
	virtual ~MemoryControlGroup() {}

	// CONST METHODS
	const std::string getGroupName() const {return m_control_group_name;}
	const FifoConfig &getCommandFifoConfig() const {return m_command_fifo_config;}
	const FifoConfig &getEchoFifoConfig() const {return m_echo_fifo_config;}
	const FifoConfig &getDataFifoConfig() const {return m_data_fifo_config;}
	const std::string getCommandStreamName() const;
	const FifoCommandStreamPtr getCommandInputStream() const {return m_command_input_buffer;};
	const FifoCommandEchoStreamPtr getCommandEchoStream() const {return m_command_echo_buffer;};
	bool isCommandInputStalled() const;

	// MODIFIERS
	const FifoCommandEchoStreamPtr addCommandEchoStream(std::string &name);
	const FifoInputStreamPtr  addInputStream(std::string &name); // changes name to the "real" name of the stream
	const FifoOutputStreamPtr addOutputStream(std::string &name);// changes name to the "real" name of the stream
	void finalise();
	bool fetchAndQueueCommands();
	bool pushCommand(const Data& command);
	void newCycle();
	// retrieves the input/output stream according to the stream-select number given in
	// the command stream
	InputOutputStreamPtr getStream(const Data &commandIndex);
};
typedef std::shared_ptr<MemoryControlGroup> MemoryControlGroupPtr;




/***********************************
 *
 * Main MemoryControllerPro class
 *
 ***********************************/

class MemoryControllerPro;
typedef MemoryControllerPro* MemoryControllerProPtr;

class MemoryControllerPro:
	public ManagerBlockIrqSync
{
private:
	FifoConfig m_data_fifo_config;
	FifoConfig m_command_fifo_config;
	FifoConfig m_echo_fifo_config;
	int m_group_count;
	size_t m_current_stream;
	bool m_initialized;
	bool m_and_interrupt_on;
	std::vector<MemoryControlGroupPtr> m_control_groups;
	std::vector<InputOutputStreamPtr> m_streams;
	Data m_interrupt_streams;
	Data m_disable_or;
	Data m_enable_and;
	Data m_zerovec;
	bool m_interrupt_enabled;

protected:

	MappedRegisterPtr m_reg_int_enable_and;
	MappedRegisterPtr m_reg_int_disable_or;

	// status regs, according to memory controller pro document
	MappedRegisterPtr m_reg_no_rdstreams;
	MappedRegisterPtr m_reg_no_wrstreams;
	MappedRegisterPtr m_reg_phy_init_done;
	MappedRegisterPtr m_reg_memctrl_idle;
	MappedRegisterPtr m_reg_memcmd_qempty;
	MappedRegisterPtr m_reg_memcmd_full;
	std::vector<MappedRegisterPtr> m_reg_debug_cmd_counters;
	std::vector<MappedRegisterPtr> m_reg_debug_data_counters;

	// configuration given by user
	MemoryControllerConfigPtr m_configuration;
	MemoryControllerRAMInterfacePtr m_memory;

	uint32_t m_flagsRegister;
public:
	MemoryControllerPro(
			const std::string &name,
			MemoryControllerConfigPtr configuration);

	virtual ~MemoryControllerPro();

	// CONST METHODS
	MemoryControlGroupPtr getMemoryControlGroup(const std::string &name) const;
	MemoryControlGroupPtr getMemoryControlGroupByCommandStreamName(const std::string &name) const;
	bool hasOutputStream(const std::string &name) const;
	FifoOutputStreamPtr getOutputStream(const std::string &name) const;
	bool hasInputStream(const std::string &name) const;
	FifoInputStreamPtr getInputStream(const std::string &name) const;
	bool hasCommandStream(const std::string &name) const;
	FifoCommandStreamPtr getCommandStream(const std::string &name) const;
	FifoCommandEchoStreamPtr getCommandEchoStream(const std::string &name) const;
	MemoryControllerConfigPtr getConfiguration() const {return m_configuration;}
	bool hasInterruptEnabled(){return m_interrupt_enabled;}

	// MOIFIERS
	MemoryControlGroupPtr addMemoryControlGroup(const std::string name);
	void streamsFinalise(); // construct interface
	virtual void reset();
	virtual bool runCycle();
};



/*
 * Because MemoryController is not part of the design (it is a component that is
 * hidden in the graph), but has inputs and outputs that are visible blocks, we
 * need two proxy classes that we can instantiate in the graph.
 */

/*MEM_PULL_SOURCE*/
class MemoryProxyPullSourceSync:
	public PullSourceSync,		// interface to outside
	public PullSinkSync

{
private:
	MemoryControllerProPtr m_controller;
	FifoOutputStreamPtr m_stream_to_proxy;
	std::string m_source_name;
	t_port_number m_source_port;
	uint32_t m_output_width;
	uint32_t m_widthDiff;
	uint32_t m_numEngines;
	uint32_t m_bitsPerEngine;
	uint32_t m_dataBitsPerEngine;
protected:
	virtual const Data &peekOutput(const t_port_number output_port) const;

	virtual void pullOutput(const t_port_number output_port);

public:
	// CONST
	virtual bool isPullOutputEmpty(const t_port_number output_port) const;
	virtual bool isPullOutputDone(const t_port_number output_port) const;

	// MODIFIERS
	MemoryProxyPullSourceSync (const std::string component_name,
			const std::string &source_name, const MemoryControllerProPtr memory_to_proxy);
	MemoryProxyPullSourceSync (const std::string component_name);
	virtual ~MemoryProxyPullSourceSync() throw() {}

	void setup(const std::string &source_name,
			const MemoryControllerProPtr memory_to_proxy,
			const std::string &command_channel_name,
			const uint32_t output_width);
	virtual void reset();
	virtual bool runCycle();
};

/*MEM_PUSH_SINK*/
class MemoryProxyPushSinkSync:
	public PushSinkSync,
	public PushSourceSync
{
private:
	MemoryControllerProPtr m_controller;
	FifoInputStreamPtr m_stream_to_proxy;
	std::string m_sink_name;
	t_port_number m_sink_port;
	size_t m_data_written_ctr;
	uint32_t m_busWidth;
	uint32_t m_widthDiff;
	uint32_t m_numEngines;
	uint32_t m_bitsPerEngine;
	uint32_t m_numParityBitsPerEngine;
	uint32_t m_dataBitsPerEngine;
	Data m_parityEccClearMask;
public:
	// CONST
	virtual bool isPushInputStalled(const t_port_number input_port) const;


	// MODIFIERS
	MemoryProxyPushSinkSync(const std::string &component_name,
			const std::string &sink_name, const MemoryControllerProPtr memory_to_proxy);
	MemoryProxyPushSinkSync(const std::string &component_name);
	virtual ~MemoryProxyPushSinkSync() throw() {}

	void setup(const std::string &sink_name,
			const MemoryControllerProPtr memory_to_proxy,
			const std::string &command_channel_name,
			const uint32_t input_width);
	virtual void reset();
	virtual bool runCycle();
	virtual void pushInput(const t_port_number input_port, const Data &data);
};


/*MEM_COMMAND_SINK*/
class MemoryProxyCommandSinkSync:
	public PushSinkSync,
	public PushSourceSync
{
private:
		MemoryControllerProPtr m_controller;
		MemoryControlGroupPtr m_control_group;
		FifoCommandStreamPtr m_stream_to_proxy;
		std::string m_command_sink_name;
		t_port_number m_command_sink_port;
public:
		// CONST
		virtual bool isPushInputStalled(const t_port_number input_port) const;

		//MODIFIERS
		MemoryProxyCommandSinkSync(const std::string &component_name,
				const std::string &command_sink_name, const MemoryControllerProPtr memory_to_proxy);
		MemoryProxyCommandSinkSync(const std::string &component_name);
		virtual ~MemoryProxyCommandSinkSync() throw() {}

		void setup(const std::string &command_sink_name, const MemoryControllerProPtr memory_to_proxy);
		virtual void reset();
		virtual bool runCycle();
		virtual void pushInput(const t_port_number input_port, const Data &data);
};

/*MEMORY_COMMAND_COMPLETION SOURCE*/
class MemoryProxyCommandEchoSourceSync:
	public PullSourceSync,
	public PullSinkSync
{
private:
	MemoryControllerProPtr m_controller;
	MemoryControlGroupPtr m_control_group;
	FifoCommandEchoStreamPtr m_stream_to_proxy;
	std::string m_source_name;
	t_port_number m_source_port;
protected:
	virtual const Data &peekOutput(const t_port_number output_port) const;

	virtual void pullOutput(const t_port_number output_port);

public:
	// CONST
	virtual bool isPullOutputEmpty(const t_port_number output_port) const;
	virtual bool isPullOutputDone(const t_port_number output_port) const;

	// MODIFIERS
	MemoryProxyCommandEchoSourceSync (const std::string component_name,
			const std::string &source_name, const MemoryControllerProPtr memory_to_proxy);
	MemoryProxyCommandEchoSourceSync (const std::string component_name);
	virtual ~MemoryProxyCommandEchoSourceSync() throw() {}

	void setup(const std::string &source_name, const MemoryControllerProPtr memory_to_proxy,
			const std::string &command_channel_name);
	virtual void reset();
	virtual bool runCycle();
};


} // namespace

#endif /* MEMORYCONTROLLERPRO_H_ */
