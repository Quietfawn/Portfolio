module baud_tick #(
  parameter int baudrate = 115200,
  parameter int clkHz = 100_000_000
)
(
  input logic clk,
  input logic rst,
  output logic baud_clk
);

  logic [$clog2(clkHz/(2*baudrate))-1 : 0]  counter;

  always_ff @(posedge clk or posedge rst ) begin : baud_tick_generator
    if (rst) begin
      baud_clk <= '0;
      counter <= '0;
    end else begin
      counter <= counter + 1'b1;
      if (counter == clkHz/(2*baudrate)) begin
        baud_clk <= ~baud_clk;
      end
    end


  end

endmodule



module uart_tx #(
  parameter int baudrate = 115200,
  parameter int clkHz = 100_000_000   
)
(
  input logic clk,
  input logic rst,
  input logic baud_tick,
  input logic [7:0] data,
  input logic data_in_valid,
  output logic data_out,
  output logic data_in_ready
)

  typedef enum logic [1:0] { 
    IDLE,
    START,
    TX

  } state_t;

  state_t state_r;

  logic [7:0] data_r;

  always_ff @(posedge clk or posedge rst) begin

    if(rst) begin

      state_r <= IDLE;
      data_out <= 1'b1;
      data_in_ready <= 1'b0;

    end else begin

    case (state_r)
    
      IDLE: begin

      end

      START: begin
      
      end

      TX: begin

      end


    endcase

  end

endmodule
