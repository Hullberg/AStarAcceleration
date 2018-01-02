#include "PipelinedStreams.h"
#include <string>

#define INPUT_NAME "input"
#define OUTPUT_NAME "output"

namespace maxcompilersim {

// Push Pipeline Sync implementation
PushPipelineSync::PushPipelineSync(std::string name, int depth, int width) :
		ManagerBlockSync(name),
		m_depth(depth),
		m_width(width),
		m_outputData(width),
		m_hasData(false) {
	registerPushInput(INPUT_NAME);
	registerPushOutput(OUTPUT_NAME);
}

bool PushPipelineSync::runCycle(void) {
	if (m_hasData && !isPushOutputStalled(0)) {
		pushOutput(0, m_outputData);
		m_hasData = false;
	}
	return false;
}

void PushPipelineSync::pushInput(t_port_number port_number, const Data &data) {
	// TODO - Implement proper pipelining based on depth
	if (isPushOutputStalled(port_number)) {
		if (m_hasData) {
			std::cout << "Error on transfer\n";
		}
		m_outputData = data;
		m_hasData = true;
	} else {
		pushOutput(port_number, data);
	}
}

bool PushPipelineSync::isPushInputStalled(t_port_number port_number) const {
	return isPushOutputStalled(port_number) || m_hasData;
}

// Pull Pipeline Sync implementation
PullPipelineSync::PullPipelineSync(std::string name, int depth, int width) :
		ManagerBlockSync(name),
		m_depth(depth),
		m_width(width),
		m_isEmpty(true),
		m_outputData(width),
		m_dataConsumed(true) {
	registerPullInput(INPUT_NAME);
	registerPullOutput(OUTPUT_NAME);
}

bool PullPipelineSync::isPullOutputEmpty(t_port_number output_port) const {
	return m_isEmpty;
}

void PullPipelineSync::pullOutput(t_port_number output_port) {
	m_dataConsumed = true;
}

bool PullPipelineSync::runCycle(void) {
	if (!isPullInputEmpty(0) && m_dataConsumed) {
		m_isEmpty = false;
		m_outputData = pullInput(0);
		m_dataConsumed = false;
	} else {
		m_isEmpty = true;
	}
	return false;
}

const Data &PullPipelineSync::peekOutput(t_port_number output_port) const {
	std::cout << m_outputData << std::endl;
	return m_outputData;
}

}  // namespace maxcompilersim
