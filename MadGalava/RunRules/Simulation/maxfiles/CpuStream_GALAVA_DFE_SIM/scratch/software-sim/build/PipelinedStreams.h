#ifndef PIPELINED_STREAMS_H_
#define PIPELINED_STREAMS_H_
#include "Data.h"
#include "PushSync.h"
#include "PullSync.h"

namespace maxcompilersim {

class PushPipelineSync:
	public PushSourceSync, public PushSinkSync {
 private:
	int m_width;
	int m_depth;
	std::string m_name;
	Data m_outputData;
	bool m_hasData;
 public:
	PushPipelineSync(std::string name, int depth, int width);
	virtual ~PushPipelineSync() {}
	virtual bool runCycle(void);
	virtual void reset(void) {m_hasData = false;}
 	virtual void pushInput(t_port_number port_number, const Data &data);
	virtual bool isPushInputStalled(t_port_number port_number) const;
};

class PullPipelineSync:
	public PullSourceSync, public PullSinkSync {
 private:
	int m_width;
	int m_depth;
	std::string m_name;
	Data m_outputData;
	bool m_isEmpty;
	bool m_dataConsumed;
 public:
	PullPipelineSync(std::string name, int depth, int width);
	virtual ~PullPipelineSync() {}
	virtual bool runCycle(void);
	virtual void reset(void) {m_isEmpty = true; m_dataConsumed = true;}
	virtual bool isPullOutputEmpty(t_port_number output_port) const;
	virtual void pullOutput(t_port_number output_port);
	virtual const Data &peekOutput(t_port_number output_port) const;
};

}  // namespace maxcompilersim

#endif
