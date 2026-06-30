class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  function new(string name="",uvm_componet parent);
    super.new(name,parent);
  endfunction
  
endclass
