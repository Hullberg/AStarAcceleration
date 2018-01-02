#ifndef LMEMSIMCONFIG_H_
#define LMEMSIMCONFIG_H_

#include <stdlib.h>
#include <iostream>
#include <memory>
#include <vector>
#include <string>
#include "SimException.h"
#include "Data.h"
#include "PushSync.h"

namespace maxcompilersim {

typedef std::shared_ptr<std::vector<std::string>> SimFileListPtr;

class LMemSimConfig {
 protected:
	const std::string     m_boardName;
	const size_t          m_burstSize;
	static SimFileListPtr m_simFilenameList;
	const uint64_t        m_dimmSizeBytes;
	const uint8_t         m_addrSize;
	const unsigned int    m_dataBitWidth;
	const std::string     m_dimmSuffix;
	const unsigned int    m_dimmCount;
	const unsigned int    m_dimmIndex;
	const unsigned int    m_mcpId;

	LMemSimConfig(
			const std::string board_name,
			const size_t burst_size,
			const uint64_t mem_size_bytes,
			const uint8_t addrSize,
			const unsigned dataBitWidth,
			const std::string dimmSuffix,
			const unsigned dimmCount,
			const unsigned dimmIndex,
			const unsigned mcpId)
	:
		m_boardName         (board_name),
		m_burstSize         (burst_size),
		m_dimmSizeBytes     (mem_size_bytes),
		m_addrSize          (addrSize),
		m_dataBitWidth      (dataBitWidth),
		m_dimmSuffix        (dimmSuffix),
		m_dimmCount         (dimmCount),
		m_dimmIndex         (dimmIndex),
		m_mcpId             (mcpId) {}

 public:
	std::string getGeneratedSimulationFile();

	const std::string getBoardName() const {
		return m_boardName;
	}

	const size_t getBurstSize() const {
		return m_burstSize;
	}

	const uint64_t getDimmSize() const {
		return m_dimmSizeBytes;
	}

	const uint64_t getLMemSize() const {
		return m_dimmSizeBytes * m_dimmCount;
	}

	const unsigned int getDimmCount() const {
		return m_dimmCount;
	}

	const std::string getDimmSuffix() const {
		return m_dimmSuffix;
	}

	const uint8_t getAddrSize() const {
		return m_addrSize;
	}

	const unsigned getDataBitWidth() const {
		return m_dataBitWidth;
	}

	const unsigned getDimmIndex() const {
		return m_dimmIndex;
	}

	const unsigned int getMcpId() const {
		return m_mcpId;
	}
};

// --------------- MAX 5 LIMA CONFIG ----------------------------

#define MAX5_LIMA_BOARD_NAME "Lima"
#define MAX5_LIMA_BURST_SIZE 64
#define MAX5_LIMA_DIMM_SIZE 0x400000000
#define MAX5_LIMA_ADDRESS_WIDTH 31
#define MAX5_LIMA_DATA_WIDTH 512

// TODO - These values should be adjusted for the real MAIA card
#define MAX4_MAIA_BOARD_NAME "Maia"
#define MAX4_MAIA_BURST_SIZE 64
#define MAX4_MAIA_DIMM_SIZE 0x200000000
#define MAX4_MAIA_ADDRESS_WIDTH 31
#define MAX4_MAIA_DATA_WIDTH 512

// TODO - These classes could be stored on platforms
class LMemMax5LimaConfig final : public LMemSimConfig {
 public:
	LMemMax5LimaConfig(const std::string dimmSuffix, const unsigned dimmCount,
			const unsigned dimmIndex, const unsigned mctrlgId):
		LMemSimConfig (
			MAX5_LIMA_BOARD_NAME,
			MAX5_LIMA_BURST_SIZE,
			MAX5_LIMA_DIMM_SIZE,
			MAX5_LIMA_ADDRESS_WIDTH,
			MAX5_LIMA_DATA_WIDTH,
			dimmSuffix,
			dimmCount,
			dimmIndex,
			mctrlgId) {}
	virtual ~LMemMax5LimaConfig(){}
};

// TODO Print the correct Memory configs
class LMemMax4MaiaConfig final : public LMemSimConfig {
 public:
	LMemMax4MaiaConfig(const std::string dimmSuffix, const unsigned dimmCount,
		const unsigned dimmIndex, const unsigned mctrlgId):
			LMemSimConfig (
				MAX4_MAIA_BOARD_NAME,
				MAX4_MAIA_BURST_SIZE,
				MAX4_MAIA_DIMM_SIZE,
				MAX4_MAIA_ADDRESS_WIDTH,
				MAX4_MAIA_DATA_WIDTH,
				dimmSuffix,
				dimmCount,
				dimmIndex,
				mctrlgId) {}
		virtual ~LMemMax4MaiaConfig(){}
};

// --------------------- CONFIG LOADING -----------------------------------

typedef LMemSimConfig* LMemSimConfigPtr;

template <class T>
class ConfigFactory final {
 private:
 public:
	static LMemSimConfigPtr getConfig(
			const unsigned mctrlgId,
			const std::string dimmSuffix,
			const unsigned dimmCount,
			const unsigned dimmIndex) {
		return new T(dimmSuffix, dimmCount, dimmIndex, mctrlgId);
	}
};


}  // namespace maxcompilersim
#endif
