#ifndef MANAGER_ASYNC_H_
#define MANAGER_ASYNC_H_

#include <string>
#include <vector>

#include <cstring>

#include "ManagerBlock.h"
#include "PushAsync.h"
#include "PullAsync.h"
#include "Thread.h"

namespace maxcompilersim {

class ManagerBlockAsync : public ManagerBlock {
public:
	explicit ManagerBlockAsync(const std::string &name) :
		ManagerBlock(name)
	{}

	virtual ~ManagerBlockAsync() {}

	virtual void startThread() = 0;
	virtual void stopThread() = 0;
};

class ManagerBlockSimpleAsync : public ManagerBlockAsync {
private:
  std::unique_ptr<Thread> m_thread;

public:

	virtual ~ManagerBlockSimpleAsync() {}

	virtual void startThread() {
		m_thread.reset(new Thread(&ManagerBlockSimpleAsync::threadLoop, this));
	}

	virtual void stopThread() {
		m_thread->interrupt();
		m_thread->join();
	}

protected:
	explicit ManagerBlockSimpleAsync(const std::string &name) :
		ManagerBlockAsync(name)
	{}

	virtual void runCycle() = 0;

private:
	void threadLoop() {
		for (;;) {
			if (m_thread->shouldStop())
				return;
			runCycle();
		}
	}
};

class ManagerDesignAsync {
private:
	std::vector<ManagerBlockAsync*> m_blocks;

public:
	explicit ManagerDesignAsync(const std::vector<ManagerBlockAsync *> &blocks) :
		m_blocks(blocks)
	{
		startAllThreads();
	}

	~ManagerDesignAsync() try {
		stopAllThreads();
	}
	catch (...) {}

	uint32_t getMappedElement(const uint32_t address) {
		stopAllThreads();

		uint32_t r(0);
		for (ManagerBlockAsync *p : m_blocks)
			r |= p->getMappedElement(address);

		startAllThreads();

		return r;
	}

	void setMappedElement(const uint32_t address, const uint32_t value,
							const uint mask) {
		stopAllThreads();

		for (ManagerBlockAsync *p : m_blocks)
			p->setMappedElement(address, value, mask);

		startAllThreads();
	}

	void mecWriteMappedRegisters(const uint32_t address,
									const mapped_registers_data_t *const data,
									const size_t item_count) {
		stopAllThreads();

		for (ManagerBlockAsync *p : m_blocks)
			p->mecWriteMappedRegisters(address, data, item_count);

		startAllThreads();
	}

	void mecReadMappedRegisters(const uint32_t address,
								mapped_registers_data_t *const data,
								const size_t item_count)  {
		stopAllThreads();

		std::memset(data, '\0', item_count * sizeof *data);

		for (ManagerBlockAsync *p : m_blocks)
			p->mecReadMappedRegisters(address, data, item_count);

		startAllThreads();
	}

	void mecWriteMappedMemories(const uint32_t address,
								const mapped_memories_data_t *const data,
								const size_t item_count) {
		stopAllThreads();

		for (ManagerBlockAsync *p : m_blocks)
			p->mecWriteMappedMemories(address, data, item_count);

		startAllThreads();
	}

	void mecReadMappedMemories(const uint32_t address,
								mapped_memories_data_t *const data,
								const size_t item_count) {
		stopAllThreads();

		std::memset(data, '\0', item_count * sizeof *data);

		for (ManagerBlockAsync *p : m_blocks)
			p->mecReadMappedMemories(address, data, item_count);

		startAllThreads();
	}

	void reset() {
		startAllThreads();

		for (ManagerBlockAsync *p : m_blocks)
			p->resetBlock();

		stopAllThreads();
	}

private:
	void startAllThreads() {
		for (ManagerBlockAsync *p : m_blocks)
			p->startThread();
	}

	void stopAllThreads() {
		for (ManagerBlockAsync *p : m_blocks)
			p->stopThread();
	}
};

} // namespace maxcompilersim

#endif // MANAGER_ASYNC_H_
