module WaveformGenerator(
    input wire clk,
    input wire reset,
    input [7:0] inSine,
    output reg [7:0] outR,
    output reg [7:0] outS,
    output reg [7:0] outTri,
    output reg [7:0] outTra,
    output reg [7:0] outSine,
    output reg [7:0] outHalf,
    output reg [7:0] outFull);
    
    wire [7:0] count;

    Counter8bit counter(clk, reset, count);


    always @(posedge clk) begin
        outR <= 8'd255 / (8'd255 - count);
    end
    //squre
    always @(posedge clk) begin
        if (count <= 8'd127)
            outS <= 8'd255;
        else
            outS <= 8'b0;
    end

    //Triangle
    always @(posedge clk) begin
        if (count <= 8'd127)
            outTri <= (count << 1);
        else
            outTri <= 9'd511 - (count << 1);
    end

    //Trapezius
    always @(posedge clk) begin
        if (count <= 8'd63)
            outTra <= 9'd511 - (count << 2);
        else if (count <= 8'd192)
            outTra <= 8'd0;
        else
            outTra <= (count << 2);
            
    end

    always @(posedge clk) begin
        outSine <= inSine;
    end 

    always @(posedge clk) begin
        if (inSine <= 8'd127)
            outHalf <= 8'd127;
        else
            outHalf <= inSine;
    end

    always @(posedge clk) begin
        if (inSine <= 8'd127)
            outFull <= (8'd255 - inSine);
        else
            outFull <= inSine;
           
    end

endmodule

module Counter8bit(
    input wire clk,
    input wire reset,
    output reg [7:0] count);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 8'b0;
        else
            count <= count + 1;
    end

endmodule

