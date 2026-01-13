`timescale 1ns/1ps

module uart_tick_gen_tb;

    logic clk;
    logic rst;
    logic uart_tick;


    baud_tick DUT (
        .clk(clk),
        .rst(rst),
        .baud_clk(uart_tick)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst <= 1'b1;
        #10 rst <= 1'b0;
    end



endmodule