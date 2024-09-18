`timescale 1ns/1ns
module tb();
    reg clk = 0;
    reg reset;
    reg w_start;
    reg [4:0] vi;
    reg [1:0] ui;
    wire done;
    wire wr_req;
    wire [20:0] out;
    wire [15:0] vi_res;

    always #10 clk = ~clk;

    concat cc(.vi(vi),
    .result(vi_res));

    Wrapper rr(
    .clk(clk),
    .rst(reset),
    .w_start(w_start),
    .vi(vi_res),
    .ui(ui),
    .done(done),
    .wr_req(wr_req),
    .out(out)
);

    initial begin

        w_start = 1'b0;
        vi = 5'b11111;
        ui = 2'b01;
        reset = 1'b0;    
        #20 reset = 1'b1;    
        #20 reset = 1'b0;    


        // #20 w_start = 1'b1;
        #20 w_start = 1'b0;
        #20 w_start = 1'b1;
        #20 w_start = 1'b0;

        #4000 $finish;
    end

endmodule