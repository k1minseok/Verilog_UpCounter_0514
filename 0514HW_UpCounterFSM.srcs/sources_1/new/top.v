`timescale 1ns / 1ps


module top (
    input reset,
    input en,
    input clk,

    output [3:0] fndCom,
    output [7:0] fndFont
);

    wire w_btn_en, w_tick_counter, w_counterState;
    wire [13:0] w_counter;

    button U_Button_en (
        .clk(clk),
        .in (en),

        .out(w_btn_en)
    );

    stateSelecter U_counterState (
        .in(w_btn_en),
        .reset(reset),
        .clk(clk),

        .out(w_counterState)
    );

    clkDiv #(
        .HERZ(50)
    ) U_ClkDiv_counter (
        .clk  (clk),
        .reset(reset),

        .o_clk(w_tick_counter)
    );

    UpCounter #(
        .MAX_NUM(10000)
    ) U_UpCounter_10k (
        .clk(clk),  // system operation clock, 100MHz
        .reset(reset),
        .tick(w_tick_counter),  // time clock ex) 100Hz 0.01s
        .en(w_counterState),

        .counter(w_counter)
    );

    FNDContorller U_FNDController_upcounter (
        .reset(reset),
        .clk  (clk),
        .digit(w_counter),

        .fndFont(fndFont),
        .fndCom (fndCom)
    );
endmodule