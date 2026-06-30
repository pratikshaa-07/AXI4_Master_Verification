class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  //virtual inf
  virtual inf.MON vif;
  //to 
  int i;
  function new(string name="",uvm_component parent);
    super.new(name,parent);
    i=0;
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(4)@(vif.mon_cb);
    forever
      begin
        mon();
      end
  endtask

  task mon();
    
  endtask
  
endclass
