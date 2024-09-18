module ShiftReg (
    input wire clk,
    input wire reset,
    input wire load,
    input wire shift_in,
    input wire [15:0] in,
    output wire [15:0] shift_out
);

    reg [15:0] x;

    always @(posedge clk or posedge reset) begin
        if (reset)
            x <= 16'b0;
        else if (load)
            x <= in;
        else if (shift_in)
            x <= {x[14:0], 1'b0};
    end

    assign shift_out = x;

endmodule