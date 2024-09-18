module PWM(
    input clk,
    input rst,
    input [7:0] in,
    output out);

    reg [7:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 8'b0;
        else
            count <= count + 1'b1;
    end

    assign out = (in > count) ? 1'b1 : 1'b0;

endmodule