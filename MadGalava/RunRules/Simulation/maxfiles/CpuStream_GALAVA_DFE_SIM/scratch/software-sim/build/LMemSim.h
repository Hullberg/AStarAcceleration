#ifndef LMEMSIM_H_
#define LMEMSIM_H_

#include "LMemSimConfig.h"
#include "LMemSimRAM.h"
#include "PushSync.h"
#include "ManagerSync.h"
#include "PullSync.h"
#include <unordered_map>
#include <string>
#include <vector>

namespace maxcompilersim {

typedef struct {
	uint8_t m_countdown;
	Data m_readData;
} t_readFifoElement;

class LMemSim final:
	public PullSinkSync,
	public PushSourceSync {
 private:
	// Queue to delay read data back to the user.
	// This will simulate real behaviour of the DDR IP core.
	typedef std::vector<t_readFifoElement> t_readDataQueue;

	t_readDataQueue m_readQueue;
	bool m_initialized;
	uint64_t m_cycleCounter;
	// Board configuration
	LMemSimConfigPtr m_configuration;
	// RAM simulator
	LMemSimRAM* m_ramSimulator;
	Data m_cmdStreamInput;
	bool m_hasRamDevice;
 public:
	LMemSim(const std::string &name, LMemSimConfigPtr configuration);
	virtual ~LMemSim();
	virtual void reset();
	virtual bool runCycle();
};

/*
 * Will generate the interrupt
 */
class McpInterruptGen final:
	public ManagerBlockIrqSync {
 public:
	explicit McpInterruptGen(std::string name):
		ManagerBlockIrqSync(name) {}
	virtual ~McpInterruptGen() {}
	virtual bool runCycle() {return true;}
	virtual void reset() {}
	void sendInterruptSignal() {signalInterrupt();}
};

typedef McpInterruptGen* McpInterruptGenPtr;

class McpInterruptSource final:
	public PushSinkSync {
 private:
	std::string m_name;
	bool m_receivedInterrupt;
	McpInterruptGenPtr m_intSrc;
 public:
	explicit McpInterruptSource(std::string name):
		ManagerBlockSync(name),
		m_name (name),
		m_receivedInterrupt (false) {
		registerPushInput("Tag_In");
		m_intSrc = new McpInterruptGen(name);
	}
	virtual ~McpInterruptSource() {}
	virtual void reset() {}
	virtual bool runCycle() {return true;}
	virtual bool isPushInputStalled(t_port_number port_number) const {
		return false;
	}
	McpInterruptGenPtr getInterruptGenerator() const {return m_intSrc;}
	virtual void pushInput(t_port_number port, const Data &data) {
		std::cout << "Interrupt source '" << m_name
				<< "' has received a stream interrupt.\n";
		m_intSrc->sendInterruptSignal();
	}
};

typedef McpInterruptSource* McpInterruptSourcePtr;

}  // namespace maxcompilersim

#endif
