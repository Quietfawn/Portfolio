`timescale 1 ns / 10 ps

module rmii_tx_tb #();

logic rst;
logic data_valid;
logic [7:0] data;;
logic clk;
logic tx_en;
logic [1:0] txd;
logic tx_rdy;

rmii_tx DUT (.*);


initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst <= 1'b1;
    data <= 8'b10101010;
    data_valid <= 1'b1;
    #10 rst <= 1'b0;

    
end


endmodule