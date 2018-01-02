/**
 * This bloody awful code exists as a way to workaround the lack of proper
 * IO simulation in the manager. Yes, we are creating a FIFO within this block
 * to allow for the fact that the FIFO block doesn't correctly model a FIFO!
 *
 * This code is basically a copy-paste of ManagerStateMachine_IO.h
 */
#ifndef MANAGERSTATEMACHINE_IO_H
#define MANAGERSTATEMACHINE_IO_H

#include <deque>
#include "varint_u.h"
#include "SimException.h"

namespace maxcompilersim {

class PullInput {
private:
	Data m_data;
	Data m_next_data;
	bool m_haveData;

public:
	const t_port_number port;
	bool read;

	PullInput(const t_port_number port, uint width)
	 : m_data(width), m_next_data(width), m_haveData(false), port(port), read(false) {}

	void reset() {
		clearData();
		m_data = Data(m_data.size());
		read = false;
	}

	void clearData() {
		m_data = m_next_data;
		m_next_data = Data(m_data.size());
		m_haveData = false;
	}

	void setData(const Data &data) {
		m_next_data = data;
		m_haveData = true;
	}

	bool signalEmpty() const { return !m_haveData; }
	const Data &getData() const { return m_data; }
};

class PullOutput {
private:
	Data m_data;
	bool m_haveData;
	bool m_did_read;

public:
	const t_port_number port;
	bool read;

	PullOutput(const t_port_number port, uint width)
	 : m_data(width), m_haveData(false), m_did_read(false), port(port), read(false) {}

	void reset() {
		read = false;
		m_did_read = false;
		pullAndClearData();
	}

	void pullAndClearData() {
		m_data = Data(m_data.size());
		m_haveData = false;
	}

	void setData(const Data &data) {
		m_data = data;
		m_haveData = true;
	}

	bool hadReadInLastCycle() const { return m_did_read; }
	void newCycle(bool newReadValue) { m_did_read = read; read = newReadValue;}
	bool haveData() const { return m_haveData; }
	const Data &peek() const { return m_data; }
};

class PushInput {
private:
	std::deque<Data> m_buffer;
	int m_latency;

	void push_back(const Data &data) {
		if (m_buffer.size() > m_latency + 1)
			throw SimException(bfmt("DataFlow: Push input full!"));
		m_buffer.push_back(data);
	}

public:
	const t_port_number port;
	bool m_stalled;

	PushInput(const t_port_number port, uint width, uint latency)
	 : m_latency(latency), port(port), m_stalled(true) {}

	void reset() {
		m_buffer.clear();
		m_stalled = true;
	}

	void clearData() {
		if (valid()) {
			m_buffer.pop_front();
		}
	}

	void pushInput(const Data &data) {
		push_back(data);
	}

	bool valid() const          {return !m_stalled && !m_buffer.empty();}
	const Data& getData() const {return m_buffer.front();}
	bool isStalled() const      {return m_stalled;}
};


class PushOutput {
private:
	bool m_output_stalled;
	bool m_report_stalled;
	std::deque<Data> m_buffer;

public:
	const t_port_number port;
	int m_latency;
	bool valid; // only used as intermediate var");

	PushOutput(const t_port_number port, uint width, uint latency)
	 : m_output_stalled(true), port(port), m_latency(latency) {}

	void reset() {
		m_buffer.clear();
		m_output_stalled = true;
		m_report_stalled = true;
		valid = false;
	}

	void pop_front() {
		m_buffer.pop_front();
	}

	void push_back(const Data &data) {
		if (m_buffer.size() > m_latency +1)
			throw SimException(bfmt("DataFlow: Push output full!"));
		m_buffer.push_back(data);
	}

	void setOutputStalled(bool value) { m_output_stalled = value; }

	bool stalled() {
		if (m_buffer.empty())
			m_report_stalled = false;
		if (m_output_stalled)
			m_report_stalled = true;
		return m_report_stalled;
	}

	bool haveData() const { return !m_buffer.empty(); }
	const Data &peek() const { return m_buffer.front(); }
};

}

#endif
