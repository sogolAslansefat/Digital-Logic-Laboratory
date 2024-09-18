module FreqSelector(
    input clk,
    input reset,
    input freq_load,
    input [4:0] init,
    output out);

    wire carry;
    reg [8:0] count;
    wire [8:0] valid_init;

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 9'b0;
        else if (freq_load)
            count <= valid_init;
        else
            count <= count + 1;
    end
    assign out = &count;

    assign valid_init[8:0] = {~init + 1'b1, 4'b0110};
    assign cnt_load = freq_load | carry;

endmodule