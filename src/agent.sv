class agent extends uvm_agent;
  driver drv;
  monitor mon;
  sequencer seqr;

  `uvm_component_utils(agent)

  function new(string name="agent",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(get_is_active()== UVM_ACTIVE)
      begin
        drv=driver::type_id::create("driver",this);
        seqr=sequencer::type_id::create("seqr",this);
      end
     mon=monitor::type_id::create("mon",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    if(get_is_active()== UVM_ACTIVE)
      begin
    drv.seq_item_port.connect(seqr.seq_item_export);
      end
  endfunction

endclass
