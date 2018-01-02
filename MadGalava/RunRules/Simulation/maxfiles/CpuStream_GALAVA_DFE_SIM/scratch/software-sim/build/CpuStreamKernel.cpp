#include "stdsimheader.h"
#include "CpuStreamKernel.h"

namespace maxcompilersim {

CpuStreamKernel::CpuStreamKernel(const std::string &instance_name) : 
  ManagerBlockSync(instance_name),
  KernelManagerBlockSync(instance_name, 12, 2, 0, 0, "",1)
, c_hw_fix_1_0_uns_bits((HWOffsetFix<1,0,UNSIGNED>(varint_u<1>(0x0l))))
, c_hw_fix_32_0_sgn_undef((HWOffsetFix<32,0,TWOSCOMPLEMENT>()))
, c_hw_fix_1_0_uns_bits_1((HWOffsetFix<1,0,UNSIGNED>(varint_u<1>(0x1l))))
, c_hw_fix_49_0_uns_bits((HWOffsetFix<49,0,UNSIGNED>(varint_u<49>(0x1000000000000l))))
, c_hw_fix_49_0_uns_bits_1((HWOffsetFix<49,0,UNSIGNED>(varint_u<49>(0x0000000000000l))))
, c_hw_fix_49_0_uns_bits_2((HWOffsetFix<49,0,UNSIGNED>(varint_u<49>(0x0000000000001l))))
{
  { // Node ID: 18 (NodeInputMappedReg)
    registerMappedRegister("io_data_w_force_disabled", Data(1));
  }
  { // Node ID: 0 (NodeInputMappedReg)
    registerMappedRegister("io_child_0_force_disabled", Data(1));
  }
  { // Node ID: 2 (NodeInput)
     m_child_0 =  registerInput("child_0",0,5);
  }
  { // Node ID: 3 (NodeInputMappedReg)
    registerMappedRegister("io_child_1_force_disabled", Data(1));
  }
  { // Node ID: 5 (NodeInput)
     m_child_1 =  registerInput("child_1",1,5);
  }
  { // Node ID: 6 (NodeInputMappedReg)
    registerMappedRegister("io_child_2_force_disabled", Data(1));
  }
  { // Node ID: 8 (NodeInput)
     m_child_2 =  registerInput("child_2",2,5);
  }
  { // Node ID: 9 (NodeInputMappedReg)
    registerMappedRegister("io_child_3_force_disabled", Data(1));
  }
  { // Node ID: 11 (NodeInput)
     m_child_3 =  registerInput("child_3",3,5);
  }
  { // Node ID: 21 (NodeOutput)
    m_data_w = registerOutput("data_w",0 );
  }
  { // Node ID: 26 (NodeConstantRawBits)
    id26out_value = (c_hw_fix_1_0_uns_bits_1);
  }
  { // Node ID: 41 (NodeConstantRawBits)
    id41out_value = (c_hw_fix_1_0_uns_bits_1);
  }
  { // Node ID: 23 (NodeConstantRawBits)
    id23out_value = (c_hw_fix_49_0_uns_bits);
  }
  { // Node ID: 27 (NodeOutputMappedReg)
    registerMappedRegister("current_run_cycle_count", Data(48), true);
  }
  { // Node ID: 40 (NodeConstantRawBits)
    id40out_value = (c_hw_fix_1_0_uns_bits_1);
  }
  { // Node ID: 29 (NodeConstantRawBits)
    id29out_value = (c_hw_fix_49_0_uns_bits);
  }
  { // Node ID: 32 (NodeInputMappedReg)
    registerMappedRegister("run_cycle_count", Data(48));
  }
}

void CpuStreamKernel::resetComputation() {
  resetComputationAfterFlush();
}

void CpuStreamKernel::resetComputationAfterFlush() {
  { // Node ID: 18 (NodeInputMappedReg)
    id18out_io_data_w_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_data_w_force_disabled");
  }
  { // Node ID: 0 (NodeInputMappedReg)
    id0out_io_child_0_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_child_0_force_disabled");
  }
  { // Node ID: 2 (NodeInput)

    (id2st_read_next_cycle) = (c_hw_fix_1_0_uns_bits);
    (id2st_last_read_value) = (c_hw_fix_32_0_sgn_undef);
  }
  { // Node ID: 3 (NodeInputMappedReg)
    id3out_io_child_1_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_child_1_force_disabled");
  }
  { // Node ID: 5 (NodeInput)

    (id5st_read_next_cycle) = (c_hw_fix_1_0_uns_bits);
    (id5st_last_read_value) = (c_hw_fix_32_0_sgn_undef);
  }
  { // Node ID: 6 (NodeInputMappedReg)
    id6out_io_child_2_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_child_2_force_disabled");
  }
  { // Node ID: 8 (NodeInput)

    (id8st_read_next_cycle) = (c_hw_fix_1_0_uns_bits);
    (id8st_last_read_value) = (c_hw_fix_32_0_sgn_undef);
  }
  { // Node ID: 9 (NodeInputMappedReg)
    id9out_io_child_3_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_child_3_force_disabled");
  }
  { // Node ID: 11 (NodeInput)

    (id11st_read_next_cycle) = (c_hw_fix_1_0_uns_bits);
    (id11st_last_read_value) = (c_hw_fix_32_0_sgn_undef);
  }
  { // Node ID: 24 (NodeCounter)

    (id24st_count) = (c_hw_fix_49_0_uns_bits_1);
  }
  { // Node ID: 30 (NodeCounter)

    (id30st_count) = (c_hw_fix_49_0_uns_bits_1);
  }
  { // Node ID: 32 (NodeInputMappedReg)
    id32out_run_cycle_count = getMappedRegValue<HWOffsetFix<48,0,UNSIGNED> >("run_cycle_count");
  }
}

void CpuStreamKernel::updateState() {
  { // Node ID: 18 (NodeInputMappedReg)
    id18out_io_data_w_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_data_w_force_disabled");
  }
  { // Node ID: 0 (NodeInputMappedReg)
    id0out_io_child_0_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_child_0_force_disabled");
  }
  { // Node ID: 3 (NodeInputMappedReg)
    id3out_io_child_1_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_child_1_force_disabled");
  }
  { // Node ID: 6 (NodeInputMappedReg)
    id6out_io_child_2_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_child_2_force_disabled");
  }
  { // Node ID: 9 (NodeInputMappedReg)
    id9out_io_child_3_force_disabled = getMappedRegValue<HWOffsetFix<1,0,UNSIGNED> >("io_child_3_force_disabled");
  }
  { // Node ID: 32 (NodeInputMappedReg)
    id32out_run_cycle_count = getMappedRegValue<HWOffsetFix<48,0,UNSIGNED> >("run_cycle_count");
  }
}

void CpuStreamKernel::preExecute() {
  { // Node ID: 2 (NodeInput)
    if(((needsToReadInput(m_child_0))&(((getFlushLevel())<((4l)+(5)))|(!(isFlushingActive()))))) {
      (id2st_last_read_value) = (readInput<HWOffsetFix<32,0,TWOSCOMPLEMENT> >(m_child_0));
    }
    id2out_data = (id2st_last_read_value);
  }
  { // Node ID: 5 (NodeInput)
    if(((needsToReadInput(m_child_1))&(((getFlushLevel())<((4l)+(5)))|(!(isFlushingActive()))))) {
      (id5st_last_read_value) = (readInput<HWOffsetFix<32,0,TWOSCOMPLEMENT> >(m_child_1));
    }
    id5out_data = (id5st_last_read_value);
  }
  { // Node ID: 8 (NodeInput)
    if(((needsToReadInput(m_child_2))&(((getFlushLevel())<((4l)+(5)))|(!(isFlushingActive()))))) {
      (id8st_last_read_value) = (readInput<HWOffsetFix<32,0,TWOSCOMPLEMENT> >(m_child_2));
    }
    id8out_data = (id8st_last_read_value);
  }
  { // Node ID: 11 (NodeInput)
    if(((needsToReadInput(m_child_3))&(((getFlushLevel())<((4l)+(5)))|(!(isFlushingActive()))))) {
      (id11st_last_read_value) = (readInput<HWOffsetFix<32,0,TWOSCOMPLEMENT> >(m_child_3));
    }
    id11out_data = (id11st_last_read_value);
  }
}

void CpuStreamKernel::runComputationCycle() {
  if (m_mappedElementsChanged) {
    m_mappedElementsChanged = false;
    updateState();
    std::cout << "CpuStreamKernel: Mapped Elements Changed: Reloaded" << std::endl;
  }
  preExecute();
  execute0();
}

int CpuStreamKernel::getFlushLevelStart() {
  return ((1l)+(3l));
}

}
