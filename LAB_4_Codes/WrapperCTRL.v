module WrapperCTRL (
    input clk,
    input rst,
    input w_start,
    input eng_done,
    output reg w_done,
    output reg w_req,
    output reg ldx,
    output reg ldu,
    output reg shiftL,
    output reg eng_start
);
    parameter idle = 0, load = 1, start_exp = 2, wait_exp = 3, save = 4;
    reg [2:0] ps;
    reg [2:0] ns;
    reg cnt;
    wire co;
    wire [1:0] count;

    Counter2bit cnt2bit (
        .clk(clk),
        .rst(rst),
        .cnt(cnt),
        .count(count),
        .co(co)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ps <= idle;
        end else begin
            ps <= ns;
        end
    end

    always @(*) begin
        w_done = 0;
        w_req = 0;
        ldx = 0;
        ldu = 0;
        shiftL = 0;
        eng_start = 0;
        cnt = 0;
        case (ps)
            idle: begin
                w_done = 1;
            end
            load: begin
                ldx = 1;
                ldu = 1;
            end
            start_exp: begin
                eng_start = 1;
            end
            wait_exp: begin
                // :)))
            end
            save: begin
                w_req = 1;
                shiftL = 1;
                cnt = 1;
            end
        endcase
    end

    always @(*) begin
        case (ps)
            idle: ns = w_start ? load : idle;
            load: ns = w_start ? load : start_exp;
            start_exp: ns = wait_exp;
            wait_exp: ns = eng_done ? save : wait_exp;
            save: ns = co ? idle : start_exp;
        endcase
    end
endmodule

module Counter2bit (
    input clk,
    input rst,
    input cnt,
    output reg [1:0] count,
    output co
);

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        count <= 2'b00;
    end
    else if (cnt)
    begin
        count <= count + 1'b1;
    end
end

    assign co = ({count, cnt} == 3'b111) ? 1'b1 : 1'b0;
endmodule