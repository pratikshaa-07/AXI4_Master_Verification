// class seq_item extends uvm_sequence_item;
  
//   rand  bit [7:0]   sop;
//   randc bit [3:0]   txn_id;
//   rand bit  [31:0]  addr;
//   rand bit  [3:0]   len;
//   rand bit  [2:0]   size;
//   rand bit  [1:0]   burst;
//   rand bit  [1:0]   lock;
//   rand bit  [1:0]   cache;
//   rand bit  [2:0]   prot;
//   rand bit          strobe[];
//   rand bit  [7:0]   eop;
//   rand bit  [7:0]   data[];
//   bit       [127:0] resp_data;
//   rand bit mode;
  
//   function new(string name="");
//     super.new(name="");
//   endfunction
  
//   `uvm_object_utils_begin(seq_item)
//   `uvm_field_int(sop,UVM_ALL_ON)
//   `uvm_field_int(txn_id,UVM_ALL_ON)
//   `uvm_field_int(addr,UVM_ALL_ON)
//   `uvm_field_int(len,UVM_ALL_ON)
//   `uvm_field_int(size,UVM_ALL_ON)
//   `uvm_field_int(burst,UVM_ALL_ON)
//   `uvm_field_int(lock,UVM_ALL_ON)
//   `uvm_field_int(cache,UVM_ALL_ON)
//   `uvm_field_int(prot,UVM_ALL_ON)
//   `uvm_field_int(strobe,UVM_ALL_ON)
//   `uvm_field_int(eop,UVM_ALL_ON)
//   `uvm_field_int(data,UVM_ALL_ON)
//   `uvm_field_int(resp_data,UVM_ALL_ON)
//   `uvm_object_utils_end

//   //basic constraints 

//   constraint burst_size {
//     burst inside {0,1,2};
//   }

//   constraint sop_val {
//     sop==8'b101010110;
//   }

//   constraint eop_val {
//     eop==8'b10101001;
//   }
  
//   constraint size_val {
//     size inside {[0:4]};
//   }

//   constraint len_val {
//     len inside {[0:15]};
//   }

//   constraint data_size {
//     if(mode==0)
//       data.size()==((len+1)*(1<<size));
//     else
//       data.size()==1;
//   }

//   constraint strobe_size {
//     if(mode==0)
//       strobe.size()==data.size();
//     else
//     {
//       strobe.size()==1;
//       strobe[0]==0;
//     }
//   }

//   constraint rd_pkt_data {
//     if(mode==1)
//       data[0]==8'h00;
//   }

//   constraint wrt_pkt_data {
//     if(mode==0)
//       foreach(data[i])
//       {
//         data[i]!=sop;
//         data[i]!=eop;
//       }
//   }

class seq_item extends uvm_sequence_item;

  rand  bit [7:0]   sop;
  randc bit [3:0]   txn_id;
  rand  bit [31:0]  addr;
  rand  bit [3:0]   len;
  rand  bit [2:0]   size;
  rand  bit [1:0]   burst;
  rand  bit [1:0]   lock;
  rand  bit [1:0]   cache;
  rand  bit [2:0]   prot;
  rand  bit         strobe[];     // sized to track data (per your team's spec)
  rand  bit [7:0]   data[];
  rand  bit [7:0]   eop;
  rand  bit         mode;
  bit   [127:0]     resp_data;

  function new(string name="");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(sop,    UVM_ALL_ON)
    `uvm_field_int(txn_id, UVM_ALL_ON)
    `uvm_field_int(addr,   UVM_ALL_ON)
    `uvm_field_int(len,    UVM_ALL_ON)
    `uvm_field_int(size,   UVM_ALL_ON)
    `uvm_field_int(burst,  UVM_ALL_ON)
    `uvm_field_int(lock,   UVM_ALL_ON)
    `uvm_field_int(cache,  UVM_ALL_ON)
    `uvm_field_int(prot,   UVM_ALL_ON)
    `uvm_field_int(strobe, UVM_ALL_ON)
    `uvm_field_int(data,   UVM_ALL_ON)
    `uvm_field_int(eop,    UVM_ALL_ON)
    `uvm_field_int(resp_data, UVM_ALL_ON)   // response-only, exclude from pack
  `uvm_object_utils_end

  // ---------------- constraints ----------------
  constraint burst_size {
    burst inside {0,1,2};
  }
  constraint sop_val {
    sop == 8'b10101010;
  }
  constraint eop_val {
    eop == 8'b01010011;
  }
  constraint size_val {
    size inside {[0:4]};
  }
  constraint len_val {
    len inside {[0:15]};
  }
  constraint data_size {
    if (mode == 0)
      data.size() == ((len+1)*(1<<size));
    else
      data.size() == 1;
  }

  constraint strobe_size {
    if (mode == 0)
      strobe.size() == data.size();
    else begin
      strobe.size() == 1;
      strobe[0] == 0;
    end
  }
  constraint rd_pkt_data {
    if (mode == 1)
      data[0] == 8'h00;
  }
  constraint wrt_pkt_data {
    if (mode == 0)
      foreach (data[i]) {
        data[i] != sop;
        data[i] != eop;
      }
  }

endclass
  
// endclass
