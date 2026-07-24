class act_monitor extends uvm_monitor;
  `uvm_component_utils(act_monitor)
 
  virtual inf.MON vif;
  uvm_analysis_port #(seq_item) act_port;
 
  seq_item tr;
 
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
    send_port = new("act_port", this);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual inf.MON)::get(this, "", "vif", vif))
      `uvm_fatal("ACT_MON", "Unable to access Interface");
  endfunction
 
  task run_phase(uvm_phase phase);
    repeat(4) @(vif.mon_cb);
    forever begin
      tr = seq_item::type_id::create("tr");
      tr.wr_en   = vif.mon_cb.wr_en;
      tr.wr_data = vif.mon_cb.wr_data;
      tr.rd_en   = vif.mon_cb.rd_en;
      act_port.write(tr);
      @(vif.mon_cb);
    end
  endtask
 
endclass
