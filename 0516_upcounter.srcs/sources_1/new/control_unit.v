`timescale 1ns / 1ps


module control_unit (
    input clk,
    input reset,
    input btn_run_stop,
    input btn_clear,

    output run_stop,
    output clear,
    output led_stop,
    output led_run,
    output led_clear
    //output [2:0] ledout
);

    parameter STOP = 2'd0, RUN = 2'd1, CLEAR = 2'd2;
    reg [1:0] state, state_next;
    reg run_stop_reg, run_stop_next, clear_reg, clear_next;
    //reg [2:0] ledout_reg, ledout_next;

    assign run_stop = run_stop_reg;
    assign clear = clear_reg;
    //assign ledout = ledout_reg;


    // state register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= STOP;
            run_stop_reg <= 1'b0;
            clear_reg <= 1'b0;
        end else begin
            state <= state_next;
            run_stop_reg <= run_stop_next;
            clear_reg <= clear_next;
        end
    end


    // next state combinational logic
    always @(*) begin
        state_next = state;
        case (state)
            STOP: begin
                if (btn_run_stop) state_next = RUN;
                else if (btn_clear) state_next = CLEAR;
                else state_next = STOP;
            end
            RUN: begin
                if (btn_run_stop) state_next = STOP;
                else state_next = RUN;
            end
            CLEAR: begin
                state_next = STOP;
            end
        endcase
    end


    // output combinational logic
    assign led_stop = (state == STOP) ? 1'b1 : 1'b0;
    assign led_run = (state == RUN) ? 1'b1 : 1'b0;
    assign led_clear = (state == CLEAR) ? 1'b1 : 1'b0;

    always @(*) begin
        run_stop_next = 1'b0;
        clear_next = 1'b0;
        //ledout_next = 3'b000;
        case (state)
            STOP: begin
                run_stop_next = 1'b0;
                //ledout_next   = 3'b001;
            end
            RUN: begin
                run_stop_next = 1'b1;
                //ledout_next   = 3'b010;
            end
            CLEAR: begin
                clear_next  = 1'b1;
                //ledout_next = 3'b100;
            end
        endcase
    end
endmodule
