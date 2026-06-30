class seq_item extends uvm_sequence_item;
  
  rand  bit [7:0]   sop;
  randc bit [3:0]   txn_id;
  rand bit  [31:0]  waddr;
  rand bit  [3:0]   len;
  rand bit  [2:0]   size;
  rand bit  [1:0]   burst;
  rand bit  [1:0]   lock;
  rand bit  [1:0]   cache;
  rand bit  [2:0]   prot;
  rand bit          strobe[];
  rand bit  [7:0]   eop;
  rand bit  [7:0]   data[];
  
  function new(string name="");
    super.new(name="");
  endfunction
  
  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(sop,UVM_ALL_ON)
  `uvm_field_int(txn_id,UVM_ALL_ON)
  `uvm_field_int(addr,UVM_ALL_ON)
  `uvm_field_int(len,UVM_ALL_ON)
  `uvm_field_int(size,UVM_ALL_ON)
  `uvm_field_int(burst,UVM_ALL_ON)
  `uvm_field_int(lock,UVM_ALL_ON)
  `uvm_field_int(cache,UVM_ALL_ON)
  `uvm_field_int(prot,UVM_ALL_ON)
  `uvm_field_int(strobe,UVM_ALL_ON)
  `uvm_field_int(eop,UVM_ALL_ON)
  `uvm_field_int(rdata,UVM_ALL_ON)
  `uvm_field_int(
  `uvm_object_utils_end

  //basic constraints 

  constraint burst_size {
    burst inside {0,1,2};
  }

  constraint sop_val {
    sop==8'b101010110;
  }

  constraint eop_val {
    eop==8'b10101001;
  }

  constraint 
  
  
endclass
