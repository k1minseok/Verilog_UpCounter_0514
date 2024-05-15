`timescale 1ns / 1ps

module stateSelecter (
    input in,
    input reset,
    input clk,

    output out
);

    localparam counter_ON = 1'b1, counter_OFF = 1'b0;

    reg state, state_next;

    // next state logic
    always @(state, in) begin
        state_next = state;
        case (state)
            counter_OFF: begin
                if (in == 1'b1) state_next = counter_ON;
                else state_next = state;
            end
            counter_ON: begin
                if (in == 1'b1) state_next = counter_OFF;
                else state_next = state;
            end
        endcase
    end

    // state register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= counter_OFF;
        end else begin
            state <= state_next;
        end
    end

    // output logic
    assign out = state;

endmodule


