module CombShift (
    input [17:0] main_input,
    input [1:0] shift_amount,
    output reg [20:0] shifted_output
);

    always @(*) begin
        shifted_output = {3'b0, main_input} << shift_amount;
    end

endmodule