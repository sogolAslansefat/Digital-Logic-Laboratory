module DDS (input clk, input rst, output [8:0] out);
    wire [5:0] addr;
    wire phase_pos;
    wire sign_bit;
    PhaseAccumulator pa(clk, rst, addr, phase_pos, sign_bit);

    reg [7:0] ROM [0:63];
    initial begin
        $readmemb("sine.mem", ROM);
    end

    wire [5:0] addr_ROM = phase_pos ? ~addr + 1'b1 : addr;
    wire [7:0] data_ROM = ROM[addr_ROM];

    wire [8:0] rom_data = (~|addr & phase_pos) ? 8'b11111111 : data_ROM;
    assign out = (sign_bit) ? 9'd256 - rom_data : {1'b1, rom_data};
endmodule

module PhaseAccumulator (
    input clk,
    input rst,
    output reg [5:0] addr,
    output reg phase_pos,
    output reg sign_bit);
    
    wire [5:0] count;
    wire carry;
    Counter6bit counter (clk, rst, count, carry);
    assign addr = count;

    reg [1:0] ps;
    reg [1:0] ns;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= 2'b00;
        else
            ps <= ns;
    end

    always @(carry) begin
        case (ps)
            2'b00: ns = carry ? 2'b01 : 2'b00;
            2'b01: ns = carry ? 2'b10 : 2'b01;
            2'b10: ns = carry ? 2'b11 : 2'b10;
            2'b11: ns = carry ? 2'b00 : 2'b11;
        endcase
    end

    always @(ps) begin
        case (ps)
            2'b00: begin
                phase_pos = 1'b0;
                sign_bit = 1'b0;
            end
            2'b01: begin
                phase_pos = 1'b1;
                sign_bit = 1'b0;
            end
            2'b10: begin
                phase_pos = 1'b0;
                sign_bit = 1'b1;
            end
            2'b11: begin
                phase_pos = 1'b1;
                sign_bit = 1'b1;
            end
        endcase
    end

endmodule

module Counter6bit(
    input clk,
    input rst,
    output reg [5:0] count,
    output carry);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 6'b0;
        else
            count <= count + 1'b1;
    end
    assign carry = &count;  

endmodule