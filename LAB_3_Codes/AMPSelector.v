module AMPSelector(
    input wire [7:0] data_in,
    input wire [1:0] shift_amount,
    output reg [7:0] data_out);

    always @(data_in, shift_amount) begin
        case (shift_amount)
            2'b00: data_out <= data_in;     
            2'b01: data_out <= data_in >> 1;
            2'b10: data_out <= data_in >> 2;
            2'b11: data_out <= data_in >> 3;
        endcase
    end

endmodule