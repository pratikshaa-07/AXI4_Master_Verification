class environment extends uvm_env;
  agent agt;
  scoreboard scb;
  subscriber sub;

  `uvm_component_utils(environment)
  
  function new(string name="environment",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt=agent::type_id::create("agt",this);
    scb=scoreboard::type_id::create("scb",this);
    sub=subscriber::type_id::create("sub",this); 
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);    
    agt.monitor.mon_port.connect(scb.sco_port.analysis_export);
    agt.monitor.mon_port.connect(sub.cov_port.analysis_export);
    endfunction
endclass
      
