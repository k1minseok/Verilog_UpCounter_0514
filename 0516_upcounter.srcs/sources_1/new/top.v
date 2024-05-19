`timescale 1ns / 1ps


module top (
    input clk,
    input reset,
    input btn_run_stop,
    input btn_clear,

    output [3:0] fndCom,
    output [7:0] fndFont,
    output led_clear,
    output led_run,
    output led_stop
    //output [2:0] led
);

    wire w_div_clk;
    wire w_run_stop, w_clear;
    wire [13:0] w_digit;

    clkDiv #(
        .HERZ(100)
    ) U_ClkDiv (
        .clk  (clk),
        .reset(reset),

        .o_clk(w_div_clk)
    );

    UpCounter U_UpCounter_10k (
        .clk(clk),
        .reset(reset),
        .tick(w_div_clk),
        .run_stop(w_run_stop),
        .clear(w_clear),

        .count(w_digit)
    );

    FNDContorller U_FNDController (
        .reset(reset),
        .clk  (clk),
        .digit(w_digit),

        .fndFont(fndFont),
        .fndCom (fndCom)
    );


    wire w_btn_run_stop, w_btn_clear;

    button U_Btn_RunStop (
        .clk(clk),
        .in (btn_run_stop),

        .out(w_btn_run_stop)
    );

    button U_Btn_clear (
        .clk(clk),
        .in (btn_clear),

        .out(w_btn_clear)
    );


    control_unit U_ControllUnit (
        .clk(clk),
        .reset(reset),
        .btn_run_stop(w_btn_run_stop),
        .btn_clear(w_btn_clear),

        .run_stop(w_run_stop),
        .clear(w_clear),
        .led_stop(led_stop),
        .led_run(led_run),
        .led_clear(led_clear)
        //.ledout(led)
    );


    ila_0 your_instance_name (
        .clk(clk),  // input wire clk


        .probe0(w_btn_run_stop),  // input wire [0:0]  probe0  
        .probe1(w_btn_clear),  // input wire [0:0]  probe1 
        .probe2(w_run_stop),  // input wire [0:0]  probe2 
        .probe3(w_clear),  // input wire [0:0]  probe3 
        .probe4(w_digit),  // input wire [13:0]  probe4 
        .probe5(fndCom)   // input wire [3:0]  probe5
    );

endmodule
