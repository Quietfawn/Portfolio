`timescale 1ns/1ps

module uart_tick_gen_tb;

    logic clk;
    logic rst;
    logic uart_tick;

    logic baudclk_en_n;
    logic [7:0] data;
    logic data_in_valid;
    logic data_out;
    logic data_in_ready;




    baud_tick DUT_1 (
        .clk(clk),
        .rst(baudclk_en_n),
        .baud_clk(uart_tick)
    );

    uart_tx DUT_2 (
        .clk(clk),
        .rst(rst),
        .baud_tick_r(uart_tick),
        .data(data),
        .data_out_valid(data_in_valid),
        .data_out(data_out),
        .data_out_ready(data_in_ready),
        .baudclk_en_n(baudclk_en_n)
    );



    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst <= 1'b1;
        data <= 8'b10101010;
        data_out_valid <= 1'b1;
        #10 rst <= 1'b0;
        // #12 data_in_valid <= 1'b0;

        
    end



endmodule