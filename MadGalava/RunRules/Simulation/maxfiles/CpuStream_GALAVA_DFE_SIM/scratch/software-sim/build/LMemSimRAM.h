/*
 * LMemSimRAM.h
 * Created by Pablo Quintana (pquintana@maxeler.com)
 */
#ifndef LMEMSIMRAM_H_
#define LMEMSIMRAM_H_

#include <stdio.h>
#include <string>
#include "Data.h"
#include "LMemSimConfig.h"

namespace maxcompilersim {

class LMemSimRAM {
 private:
	std::string    m_ram_filename;
	uint64_t       m_ram_size;  // In bytes
	uint64_t       *m_ram;
	unsigned int   m_burst_size;
	unsigned int   m_dimmIndex;
	unsigned int   m_dimmCount;
	int            m_fd;
	bool           m_got_ram;

 protected:
	void unlink_ram_file(void);
 public:
	explicit LMemSimRAM(LMemSimConfigPtr configuration);
	virtual ~LMemSimRAM();
	void write_ram(const Data data, const uint32_t address);
	Data read_ram(const uint32_t address);
};

}  // namespace maxcompilersim

#endif
