`timescale 1ns/1ns
module tb_exponential();
  
  reg clk=0, rst, start;
  reg [15:0] x;
  wire done;
  wire [1:0] intpart;
  wire [15:0] fracpart;
  
  exponential dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .x(x),
    .done(done),
    .intpart(intpart),
    .fracpart(fracpart)
  );
  
  initial begin
    rst = 1;
    #10rst = 0;
    start = 0;
    #10 x = 16'b1000_0000_0000_0000;
     start = 1;
    #10 start = 0;
    
    #400 x = 16'b0100_0000_0000_0000;
     start = 1;
    #10 start = 0;
    
    #400 x = 16'b1100_0000_0000_0000;
     start = 1;
    #10 start = 0;
  
    
    #100 $finish;
  end
  
  always #5 clk = ~clk;
  
endmodule