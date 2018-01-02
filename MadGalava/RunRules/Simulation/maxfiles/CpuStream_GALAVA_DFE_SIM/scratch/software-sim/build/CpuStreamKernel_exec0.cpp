#include "stdsimheader.h"

namespace maxcompilersim {

void CpuStreamKernel::execute0() {
  { // Node ID: 18 (NodeInputMappedReg)
  }
  HWOffsetFix<1,0,UNSIGNED> id19out_result;

  { // Node ID: 19 (NodeNot)
    const HWOffsetFix<1,0,UNSIGNED> &id19in_a = id18out_io_data_w_force_disabled;

    id19out_result = (not_fixed(id19in_a));
  }
  { // Node ID: 0 (NodeInputMappedReg)
  }
  HWOffsetFix<1,0,UNSIGNED> id1out_result;

  { // Node ID: 1 (NodeNot)
    const HWOffsetFix<1,0,UNSIGNED> &id1in_a = id0out_io_child_0_force_disabled;

    id1out_result = (not_fixed(id1in_a));
  }
  if ( (getFillLevel() >= (4l)))
  { // Node ID: 2 (NodeInput)
    const HWOffsetFix<1,0,UNSIGNED> &id2in_enable = id1out_result;

    (id2st_read_next_cycle) = ((id2in_enable.getValueAsBool())&(!(((getFlushLevel())>=(4l))&(isFlushingActive()))));
    queueReadRequest(m_child_0, id2st_read_next_cycle.getValueAsBool());
  }
  { // Node ID: 3 (NodeInputMappedReg)
  }
  HWOffsetFix<1,0,UNSIGNED> id4out_result;

  { // Node ID: 4 (NodeNot)
    const HWOffsetFix<1,0,UNSIGNED> &id4in_a = id3out_io_child_1_force_disabled;

    id4out_result = (not_fixed(id4in_a));
  }
  if ( (getFillLevel() >= (4l)))
  { // Node ID: 5 (NodeInput)
    const HWOffsetFix<1,0,UNSIGNED> &id5in_enable = id4out_result;

    (id5st_read_next_cycle) = ((id5in_enable.getValueAsBool())&(!(((getFlushLevel())>=(4l))&(isFlushingActive()))));
    queueReadRequest(m_child_1, id5st_read_next_cycle.getValueAsBool());
  }
  { // Node ID: 37 (NodeAdd)
    const HWOffsetFix<32,0,TWOSCOMPLEMENT> &id37in_a = id2out_data;
    const HWOffsetFix<32,0,TWOSCOMPLEMENT> &id37in_b = id5out_data;

    id37out_result[(getCycle()+1)%2] = (add_fixed<32,0,TWOSCOMPLEMENT,TONEAREVEN>(id37in_a,id37in_b));
  }
  { // Node ID: 6 (NodeInputMappedReg)
  }
  HWOffsetFix<1,0,UNSIGNED> id7out_result;

  { // Node ID: 7 (NodeNot)
    const HWOffsetFix<1,0,UNSIGNED> &id7in_a = id6out_io_child_2_force_disabled;

    id7out_result = (not_fixed(id7in_a));
  }
  if ( (getFillLevel() >= (4l)))
  { // Node ID: 8 (NodeInput)
    const HWOffsetFix<1,0,UNSIGNED> &id8in_enable = id7out_result;

    (id8st_read_next_cycle) = ((id8in_enable.getValueAsBool())&(!(((getFlushLevel())>=(4l))&(isFlushingActive()))));
    queueReadRequest(m_child_2, id8st_read_next_cycle.getValueAsBool());
  }
  { // Node ID: 9 (NodeInputMappedReg)
  }
  HWOffsetFix<1,0,UNSIGNED> id10out_result;

  { // Node ID: 10 (NodeNot)
    const HWOffsetFix<1,0,UNSIGNED> &id10in_a = id9out_io_child_3_force_disabled;

    id10out_result = (not_fixed(id10in_a));
  }
  if ( (getFillLevel() >= (4l)))
  { // Node ID: 11 (NodeInput)
    const HWOffsetFix<1,0,UNSIGNED> &id11in_enable = id10out_result;

    (id11st_read_next_cycle) = ((id11in_enable.getValueAsBool())&(!(((getFlushLevel())>=(4l))&(isFlushingActive()))));
    queueReadRequest(m_child_3, id11st_read_next_cycle.getValueAsBool());
  }
  { // Node ID: 38 (NodeAdd)
    const HWOffsetFix<32,0,TWOSCOMPLEMENT> &id38in_a = id8out_data;
    const HWOffsetFix<32,0,TWOSCOMPLEMENT> &id38in_b = id11out_data;

    id38out_result[(getCycle()+1)%2] = (add_fixed<32,0,TWOSCOMPLEMENT,TONEAREVEN>(id38in_a,id38in_b));
  }
  { // Node ID: 39 (NodeAdd)
    const HWOffsetFix<32,0,TWOSCOMPLEMENT> &id39in_a = id37out_result[getCycle()%2];
    const HWOffsetFix<32,0,TWOSCOMPLEMENT> &id39in_b = id38out_result[getCycle()%2];

    id39out_result[(getCycle()+1)%2] = (add_fixed<32,0,TWOSCOMPLEMENT,TONEAREVEN>(id39in_a,id39in_b));
  }
  HWOffsetFix<32,-2,TWOSCOMPLEMENT> id34out_output;

  { // Node ID: 34 (NodeReinterpret)
    const HWOffsetFix<32,0,TWOSCOMPLEMENT> &id34in_input = id39out_result[getCycle()%2];

    id34out_output = (cast_bits2fixed<32,-2,TWOSCOMPLEMENT>((cast_fixed2bits(id34in_input))));
  }
  { // Node ID: 35 (NodeCast)
    const HWOffsetFix<32,-2,TWOSCOMPLEMENT> &id35in_i = id34out_output;

    id35out_o[(getCycle()+1)%2] = (cast_fixed2fixed<32,0,TWOSCOMPLEMENT,TONEAREVEN>(id35in_i));
  }
  if ( (getFillLevel() >= (12l)) && (getFlushLevel() < (12l)|| !isFlushingActive() ))
  { // Node ID: 21 (NodeOutput)
    const HWOffsetFix<1,0,UNSIGNED> &id21in_output_control = id19out_result;
    const HWOffsetFix<32,0,TWOSCOMPLEMENT> &id21in_data = id35out_o[getCycle()%2];

    bool id21x_1;

    (id21x_1) = ((id21in_output_control.getValueAsBool())&(!(((getFlushLevel())>=(12l))&(isFlushingActive()))));
    if((id21x_1)) {
      writeOutput(m_data_w, id21in_data);
    }
  }
  { // Node ID: 26 (NodeConstantRawBits)
  }
  { // Node ID: 41 (NodeConstantRawBits)
  }
  { // Node ID: 23 (NodeConstantRawBits)
  }
  if ( (getFillLevel() >= (3l)))
  { // Node ID: 24 (NodeCounter)
    const HWOffsetFix<1,0,UNSIGNED> &id24in_enable = id41out_value;
    const HWOffsetFix<49,0,UNSIGNED> &id24in_max = id23out_value;

    HWOffsetFix<49,0,UNSIGNED> id24x_1;
    HWOffsetFix<1,0,UNSIGNED> id24x_2;
    HWOffsetFix<1,0,UNSIGNED> id24x_3;
    HWOffsetFix<49,0,UNSIGNED> id24x_4t_1e_1;

    id24out_count = (cast_fixed2fixed<48,0,UNSIGNED,TRUNCATE>((id24st_count)));
    (id24x_1) = (add_fixed<49,0,UNSIGNED,TRUNCATE>((id24st_count),(c_hw_fix_49_0_uns_bits_2)));
    (id24x_2) = (gte_fixed((id24x_1),id24in_max));
    (id24x_3) = (and_fixed((id24x_2),id24in_enable));
    id24out_wrap = (id24x_3);
    if((id24in_enable.getValueAsBool())) {
      if(((id24x_3).getValueAsBool())) {
        (id24st_count) = (c_hw_fix_49_0_uns_bits_1);
      }
      else {
        (id24x_4t_1e_1) = (id24x_1);
        (id24st_count) = (id24x_4t_1e_1);
      }
    }
    else {
    }
  }
  HWOffsetFix<48,0,UNSIGNED> id25out_output;

  { // Node ID: 25 (NodeStreamOffset)
    const HWOffsetFix<48,0,UNSIGNED> &id25in_input = id24out_count;

    id25out_output = id25in_input;
  }
  if ( (getFillLevel() >= (4l)) && (getFlushLevel() < (4l)|| !isFlushingActive() ))
  { // Node ID: 27 (NodeOutputMappedReg)
    const HWOffsetFix<1,0,UNSIGNED> &id27in_load = id26out_value;
    const HWOffsetFix<48,0,UNSIGNED> &id27in_data = id25out_output;

    bool id27x_1;

    (id27x_1) = ((id27in_load.getValueAsBool())&(!(((getFlushLevel())>=(4l))&(isFlushingActive()))));
    if((id27x_1)) {
      setMappedRegValue("current_run_cycle_count", id27in_data);
    }
  }
  { // Node ID: 40 (NodeConstantRawBits)
  }
  { // Node ID: 29 (NodeConstantRawBits)
  }
  if ( (getFillLevel() >= (0l)))
  { // Node ID: 30 (NodeCounter)
    const HWOffsetFix<1,0,UNSIGNED> &id30in_enable = id40out_value;
    const HWOffsetFix<49,0,UNSIGNED> &id30in_max = id29out_value;

    HWOffsetFix<49,0,UNSIGNED> id30x_1;
    HWOffsetFix<1,0,UNSIGNED> id30x_2;
    HWOffsetFix<1,0,UNSIGNED> id30x_3;
    HWOffsetFix<49,0,UNSIGNED> id30x_4t_1e_1;

    id30out_count = (cast_fixed2fixed<48,0,UNSIGNED,TRUNCATE>((id30st_count)));
    (id30x_1) = (add_fixed<49,0,UNSIGNED,TRUNCATE>((id30st_count),(c_hw_fix_49_0_uns_bits_2)));
    (id30x_2) = (gte_fixed((id30x_1),id30in_max));
    (id30x_3) = (and_fixed((id30x_2),id30in_enable));
    id30out_wrap = (id30x_3);
    if((id30in_enable.getValueAsBool())) {
      if(((id30x_3).getValueAsBool())) {
        (id30st_count) = (c_hw_fix_49_0_uns_bits_1);
      }
      else {
        (id30x_4t_1e_1) = (id30x_1);
        (id30st_count) = (id30x_4t_1e_1);
      }
    }
    else {
    }
  }
  { // Node ID: 32 (NodeInputMappedReg)
  }
  { // Node ID: 36 (NodeEqInlined)
    const HWOffsetFix<48,0,UNSIGNED> &id36in_a = id30out_count;
    const HWOffsetFix<48,0,UNSIGNED> &id36in_b = id32out_run_cycle_count;

    id36out_result[(getCycle()+1)%2] = (eq_fixed(id36in_a,id36in_b));
  }
  if ( (getFillLevel() >= (1l)))
  { // Node ID: 31 (NodeFlush)
    const HWOffsetFix<1,0,UNSIGNED> &id31in_start = id36out_result[getCycle()%2];

    if((id31in_start.getValueAsBool())) {
      startFlushing();
    }
  }
};

};
