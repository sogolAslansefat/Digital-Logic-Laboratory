module Register_2bit (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [1:0] data_in,
    output wire [1:0] data_out
);

    reg [1:0] reg_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_data <= 2'b00;
        end else if (load) begin
            reg_data <= data_in;
        end
    end

    assign data_out = reg_data;

endmodule