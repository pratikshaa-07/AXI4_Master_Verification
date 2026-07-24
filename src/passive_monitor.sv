
class pass_monitor extends uvm_monitor;
  `uvm_component_utils(pass_monitor)
 
  virtual inf.MON vif;
  uvm_analysis_port #(seq_item) pas_port;
 
  seq_item tr;
 
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
    send_port = new("pas_port", this);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual inf.MON)::get(this, "", "vif", vif))
      `uvm_fatal("PASS_MON", "Unable to access Interface");
  endfunction
 
  task run_phase(uvm_phase phase);
    repeat(4) @(vif.mon_cb);
    forever begin
      tr = seq_item::type_id::create("tr");
      tr.rd_data = vif.mon_cb.rd_data;
      pass_port.write(tr);
      @(vif.mon_cb);
    end
  endtask
 
endclass
