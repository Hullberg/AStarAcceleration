#ifndef PCIE_H_
#define PCIE_H_

#include <memory>

#include <cstdarg>
#include <stdint.h>

#include "Data.h"
#include "ManagerSync.h"
#include "PushSync.h"
#include "PullSync.h"
#include "SharedFIFO.h"

namespace maxcompilersim {

class PCIeBlockSync : public virtual ManagerBlockSync
{
protected:
	std::unique_ptr<SharedFIFO> m_fifo;

public:
	PCIeBlockSync() : ManagerBlockSync("") { }
	virtual ~PCIeBlockSync() { }

	virtual void createFIFO(const std::string &sim_prefix, int device_id, int stream_id, bool to_host);

	virtual void reset();
	virtual void abort();
};



/// PCIe data source node
class PCIePushSourceSync8 : public PCIeBlockSync, public PushSourceSync
{
protected:
	uint64_t m_data_count;

public:
	explicit PCIePushSourceSync8(const std::string & name);
	virtual ~PCIePushSourceSync8() {}

	virtual bool runCycle();
};

class PCIePullSourceSync16 : public PCIeBlockSync, public PullSourceSync
{
protected:
	uint64_t m_data_count;
	Data m_currentWord;
	bool m_currentWordValid;

	virtual const Data &peekOutput(t_port_number output_port) const;
	virtual void pullOutput(t_port_number output_port);
public:
	explicit PCIePullSourceSync16(const std::string & name);
	virtual ~PCIePullSourceSync16() {}

	virtual bool isPullOutputEmpty(t_port_number output_port) const;
	virtual bool isPullOutputDone(t_port_number output_port) const;
	virtual bool runCycle();
};

class PCIePushSourceSync16 : public PCIeBlockSync, public PushSourceSync
{
protected:
	uint64_t m_data_count;

public:
	explicit PCIePushSourceSync16(const std::string & name);
	virtual ~PCIePushSourceSync16() {}

	virtual bool runCycle();
};


/// PCIe data sink node
class PCIePushSinkSync8 : public PCIeBlockSync, public PushSinkSync
{
public:
	explicit PCIePushSinkSync8(const std::string & name);
	virtual ~PCIePushSinkSync8() {}

	virtual void pushInput(const t_port_number port_number, const Data &data);
	virtual bool isPushInputStalled(const t_port_number port_number) const;
	virtual bool runCycle() { return false; }
};

class PCIePushSinkSync16 : public PCIePushSinkSync8
{
public:
	explicit PCIePushSinkSync16(const std::string & name);
	virtual ~PCIePushSinkSync16() {}

	virtual void pushInput(const t_port_number port_number, const Data &data);
	virtual bool isPushInputStalled(const t_port_number port_number) const;
	virtual bool runCycle() { return false; }
};

} // namespace maxcompilersim

#endif // PCIE_H_
