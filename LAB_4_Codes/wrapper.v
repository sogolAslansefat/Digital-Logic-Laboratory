module Wrapper(
    input clk,
    input rst,
    input w_start,
    input [15:0] vi,
    input [1:0] ui,
    output done,
    output wr_req,
    output [20:0] out
);

    wire ldx, ldu, shiftL, eng_start;
    wire [15:0] engx;
    wire [1:0] ui_out;
    wire [1:0] int_part;
    wire [15:0] frac_part;
    wire eng_done;

    WrapperCTRL CTRL(
        .clk(clk),
        .rst(rst),
        .w_start(w_start),
        .eng_done(eng_done),
        .w_done(done),
        .w_req(wr_req),
        .ldx(ldx),
        .ldu(ldu),
        .shiftL(shiftL),
        .eng_start(eng_start)
    );

    ShiftReg SR(
        .clk(clk),
        .reset(rst),
        .load(ldx),
        .shift_in(shiftL),
        .in(vi),
        .shift_out(engx)
    );

    Register_2bit ui_reg(
        .clk(clk),
        .reset(rst),
        .load(ldu),
        .data_in(ui),
        .data_out(ui_out)
    );

    exponential EXP(
        .clk(clk),
        .rst(rst),
        .start(eng_start),
        .x(engx),
        .done(eng_done),
        .intpart(int_part),
        .fracpart(frac_part)
    );

    CombShift CS(
        .shift_amount(ui_out),
        .main_input({int_part, frac_part}),
        .shifted_output(out)
    );

endmodule