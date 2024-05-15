`timescale 1ns / 1ps


module UpCounter #(
    parameter MAX_NUM = 10000
) (
    input clk,    // system operation clock, 100MHz
    input reset,
    input tick,   // time clock ex) 100Hz 0.01s
    input en,

    output [$clog2(MAX_NUM)-1:0] counter
);

    reg [$clog2(MAX_NUM)-1:0] counter_reg, counter_next;

    // state register
    always @(posedge clk, posedge reset) begin      // clk rising edge일 때만 출력값(counter_reg) update
        if (reset) begin
            counter_reg <= 0;
        end else begin
            counter_reg <= counter_next;
        end
    end


    //next state combinational logic  <- 다음 state 값 upcount
    always @(*) begin
        if (tick & en) begin        // tick이 들어오고(x초에 한번) en 신호가 1일 때만 카운트 동작
            if (counter_reg == MAX_NUM - 1) begin
                counter_next = 0;
            end else begin
                counter_next = counter_reg + 1;
            end
        end else begin
            counter_next = counter_reg;
        end
    end


    // output combinational logic
    assign counter = counter_reg;

endmodule


// module clkDiv #(
//     parameter HERZ = 100
// ) (
//     input clk,
//     input reset,

//     output o_clk
// );

//     reg [$clog2(100_000_000/HERZ)-1 : 0] counter;
//     reg r_clk;

//     assign o_clk = r_clk;

//     always @(posedge clk, posedge reset) begin
//         if (reset) begin
//             counter <= 0;
//             r_clk   <= 1'b0;
//         end else begin
//             if (counter == (100_000_000 / HERZ - 1)) begin
//                 counter <= 0;
//                 r_clk   <= 1'b1;
//             end else begin
//                 counter <= counter + 1;
//                 r_clk   <= 1'b0;
//             end
//         end
//     end

// endmodule
