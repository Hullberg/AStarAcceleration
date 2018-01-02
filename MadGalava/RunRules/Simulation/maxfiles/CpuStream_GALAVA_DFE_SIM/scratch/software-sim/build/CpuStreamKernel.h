#ifndef CPUSTREAMKERNEL_H_
#define CPUSTREAMKERNEL_H_

// #include "KernelManagerBlockSync.h"


namespace maxcompilersim {

class CpuStreamKernel : public KernelManagerBlockSync {
public:
  CpuStreamKernel(const std::string &instance_name);

protected:
  virtual void runComputationCycle();
  virtual void resetComputation();
  virtual void resetComputationAfterFlush();
          void updateState();
          void preExecute();
  virtual int  getFlushLevelStart();

private:
  t_port_number m_child_0;
  t_port_number m_child_1;
  t_port_number m_child_2;
  t_port_number m_child_3;
  t_port_number m_data_w;
  HWOffsetFix<1,0,UNSIGNED> id18out_io_data_w_force_disabled;

  HWOffsetFix<1,0,UNSIGNED> id0out_io_child_0_force_disabled;

  HWOffsetFix<32,0,TWOSCOMPLEMENT> id2out_data;

  HWOffsetFix<1,0,UNSIGNED> id2st_read_next_cycle;
  HWOffsetFix<32,0,TWOSCOMPLEMENT> id2st_last_read_value;

  HWOffsetFix<1,0,UNSIGNED> id3out_io_child_1_force_disabled;

  HWOffsetFix<32,0,TWOSCOMPLEMENT> id5out_data;

  HWOffsetFix<1,0,UNSIGNED> id5st_read_next_cycle;
  HWOffsetFix<32,0,TWOSCOMPLEMENT> id5st_last_read_value;

  HWOffsetFix<32,0,TWOSCOMPLEMENT> id37out_result[2];

  HWOffsetFix<1,0,UNSIGNED> id6out_io_child_2_force_disabled;

  HWOffsetFix<32,0,TWOSCOMPLEMENT> id8out_data;

  HWOffsetFix<1,0,UNSIGNED> id8st_read_next_cycle;
  HWOffsetFix<32,0,TWOSCOMPLEMENT> id8st_last_read_value;

  HWOffsetFix<1,0,UNSIGNED> id9out_io_child_3_force_disabled;

  HWOffsetFix<32,0,TWOSCOMPLEMENT> id11out_data;

  HWOffsetFix<1,0,UNSIGNED> id11st_read_next_cycle;
  HWOffsetFix<32,0,TWOSCOMPLEMENT> id11st_last_read_value;

  HWOffsetFix<32,0,TWOSCOMPLEMENT> id38out_result[2];

  HWOffsetFix<32,0,TWOSCOMPLEMENT> id39out_result[2];

  HWOffsetFix<32,0,TWOSCOMPLEMENT> id35out_o[2];

  HWOffsetFix<1,0,UNSIGNED> id26out_value;

  HWOffsetFix<1,0,UNSIGNED> id41out_value;

  HWOffsetFix<49,0,UNSIGNED> id23out_value;

  HWOffsetFix<48,0,UNSIGNED> id24out_count;
  HWOffsetFix<1,0,UNSIGNED> id24out_wrap;

  HWOffsetFix<49,0,UNSIGNED> id24st_count;

  HWOffsetFix<1,0,UNSIGNED> id40out_value;

  HWOffsetFix<49,0,UNSIGNED> id29out_value;

  HWOffsetFix<48,0,UNSIGNED> id30out_count;
  HWOffsetFix<1,0,UNSIGNED> id30out_wrap;

  HWOffsetFix<49,0,UNSIGNED> id30st_count;

  HWOffsetFix<48,0,UNSIGNED> id32out_run_cycle_count;

  HWOffsetFix<1,0,UNSIGNED> id36out_result[2];

  const HWOffsetFix<1,0,UNSIGNED> c_hw_fix_1_0_uns_bits;
  const HWOffsetFix<32,0,TWOSCOMPLEMENT> c_hw_fix_32_0_sgn_undef;
  const HWOffsetFix<1,0,UNSIGNED> c_hw_fix_1_0_uns_bits_1;
  const HWOffsetFix<49,0,UNSIGNED> c_hw_fix_49_0_uns_bits;
  const HWOffsetFix<49,0,UNSIGNED> c_hw_fix_49_0_uns_bits_1;
  const HWOffsetFix<49,0,UNSIGNED> c_hw_fix_49_0_uns_bits_2;

  void execute0();
};

}

#endif /* CPUSTREAMKERNEL_H_ */
