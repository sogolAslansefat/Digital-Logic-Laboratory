module concat (
    input [4:0] vi,
    output [15:0] result
);

    assign result = {3'b000, vi, 8'b00000000};

endmodule