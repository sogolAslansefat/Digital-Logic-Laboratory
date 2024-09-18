module DataPath (
    input clk,
    input clkEn,
    input rst,
    input serIn,
    input cnt1,
    input cnt2,
    input cntD,
    input ldcntD,
    input shEn,
    input shEnD,
    output co1,
    output co2,
    output coD,
    output [3:0] P0,
    output [3:0] P1,
    output [3:0] P2,
    output [3:0] P3,
    output [6:0] ssdOut);

    wire [1:0] portNum;
    wire [3:0] countOut;
    wire [3:0] numData;

    shReg #(.bit(2)) psr(clk, clkEn, rst, shEn, serIn, portNum);
    shReg #(.bit(4)) dsr(clk, clkEn, rst, shEnD, serIn, numData);

    UCounter pc (clk, clkEn, rst, cnt1, co1); 
    UCounter dnc(clk, clkEn, rst, cnt2, co2); 
    Dcounter dtc(clk, clkEn, rst, ldcntD, cntD, numData, countOut, coD); 

    SSD ssd(countOut, ssdOut);

    Demux dmx(portNum, P0, P1, P2, P3);

endmodule

module SSD (
    input      [3:0] count,
    output reg [6:0] ssdOut);

    always @(count) begin
        ssdOut = 4'h0;
        case (count)
            4'h0: ssdOut = 7'h40;
            4'h1: ssdOut = 7'h79;
            4'h2: ssdOut = 7'h24;
            4'h3: ssdOut = 7'h30;
            4'h4: ssdOut = 7'h19;
            4'h5: ssdOut = 7'h12;
            4'h6: ssdOut = 7'h02;
            4'h7: ssdOut = 7'h78;
            4'h8: ssdOut = 7'h00;
            4'h9: ssdOut = 7'h10;
            4'ha: ssdOut = 7'h08;
            4'hb: ssdOut = 7'h03;
            4'hc: ssdOut = 7'h46;
            4'hd: ssdOut = 7'h21;
            4'he: ssdOut = 7'h06;
            4'hf: ssdOut = 7'h0e;
            default: ssdOut = 7'h01;
        endcase
    end
endmodule

module ShReg #(parameter bit = 2) (
    input clk,
    input clkEn,   
    input rst,
    input shEn,
    input serIn,
    output reg [bit - 1:0] parOut);

    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1)
            parOut <= 0;
        else if (clkEn == 1'b1) begin
        if (shEn == 1'b1)
            parOut <= {parOut[bit - 2:0], serIn};
        end
    end
endmodule

module UCounter #(parameter bit = 2) (
    input clk,
    input clkEn,
    input rst,
    input cnt,
    output co);
    reg [bit - 1:0] parOut;
    always @(posedge clk, posedge rst) begin
        if (rst)
            parOut <= 2'b0;
        else if (clkEn)
            if (cnt)
                parOut <= parOut + 1'b1;
    end
    assign co = (& parOut);
endmodule

module Dcounter (
    input clk,
    input clkEn,
    input rst,
    input ldcntD,
    input cntD,
    input [3:0] parIn,
    output reg [3:0] parOut,
    output coD);

    always @(posedge clk, posedge rst) begin
        if (rst)
            parOut <= 4'b0;
        else if (clkEn) begin
            if (ldcntD)
                parOut <= parIn;
            else if (cntD)
                parOut <= parOut - 1'b1;
        end
    end
    assign coD = (| parOut);
endmodule

module Demux (
    input [3:0] in,
    input [1:0] sel,
    output reg [3:0] out0,
    output reg [3:0] out1,
    output reg [3:0] out2,
    output reg [3:0] out3);

    always @(in, sel) begin
        {out0, out1, out2, out3} = 4'b0;
        case (sel)
            2'd0: out0 <= in;
            2'd1: out1 <= in;
            2'd2: out2 <= in;
            2'd3: out3 <= in;
        endcase
    end
endmodule

