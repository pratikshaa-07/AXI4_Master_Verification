class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(seq_item) wr_mon_fifo;   // from write-fifo monitor
  uvm_tlm_analysis_fifo #(seq_item) rd_mon_fifo;   // from read-fifo monitor

  // reference models mimicking actual fifo contents
  bit [127:0] wr_fifo_model[$];
  bit [127:0] rd_fifo_model[$];
  int req_data_bits;
  bit [31:0] addr[bit[3:0]];
  bit [1023:0] data [bit[3:0]];
  int len [bit[3:0]];

  bit[31:0] addr;
  bit[3:0] id;
  
  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_mon_fifo = new("wr_mon_fifo", this);
    rd_mon_fifo = new("rd_mon_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      begin
        forever begin
          seq_item tx;
          wr_mon_fifo.get(tx);
          store_wr_pkt(tx);
        end
      end
      begin
        forever begin
          seq_item tx;
          rd_mon_fifo.get(tx);
          store_rd_pkt(tx);
        end
      end
    join
  endtask

  task store_wr_pkt(seq_item tx);
    bit predicted_full;

    // only a real push happened if wr_en was high and dut wasn't already full
    if (tx.wr_en && !tx.full)
      wr_fifo_model.push_back(tx.wrt_pkt);

    predicted_full = (wr_fifo_model.size() == 4096);

    if (predicted_full !== tx.full)
      `uvm_error("SCBD_WR",
        $sformatf("full MISMATCH: model_size=%0d predicted_full=%0b dut_full=%0b",
                   wr_fifo_model.size(), predicted_full, tx.full))
    else
      `uvm_info("SCBD_WR",
        $sformatf("full OK: model_size=%0d full=%0b", wr_fifo_model.size(), tx.full),
        UVM_HIGH)
  endtask

  task store_rd_pkt(seq_item tx);
    bit predicted_empty;

    // a real pop happened if rd_en was high and dut wasn't already empty
    if (tx.rd_en && !tx.empty && rd_fifo_model.size() > 0)
      void'(rd_fifo_model.pop_front());

    predicted_empty = (rd_fifo_model.size() == 0);

    if (predicted_empty !== tx.empty)
      `uvm_error("SCBD_RD",
        $sformatf("empty MISMATCH: model_size=%0d predicted_empty=%0b dut_empty=%0b",
                   rd_fifo_model.size(), predicted_empty, tx.empty))
    else
      `uvm_info("SCBD_RD",
        $sformatf("empty OK: model_size=%0d empty=%0b", rd_fifo_model.size(), tx.empty),
        UVM_HIGH)
  endtask
      
task store_wrt_pkt();'
  if(!wr_en)
    begin
    end
  else if(q.size()==4096)
    begin
    end
  else if(wr_en && first_done==0)
    begin
      if(req.wrt_data[72:79]==8'b00101010 && req.wrt_data[a:b]==8'b001010)
        begin
          addr=req.wrt_data[a:b];
          if(arr.exists(addr))
            begin
              q.push_back(arr[addr]);
            end
          else
            begin
              
            end
        end
      else
        begin
          if(
        end
    end
  else if(wr_en && first_done==1)
    begin
    end
endtask

task store_rd_pkt();
  
endtask

endclass
