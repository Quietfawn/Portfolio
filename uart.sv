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
  input logic baud_tick_r,
  input logic [7:0] data,
  input logic data_in_valid,
  output logic data_out,
  output logic data_in_ready,
  output logic baudclk_en_n
);

  typedef enum logic [1:0] { 
    IDLE,
    START,
    TX,
    XXX = 'x

  } state_t;

  state_t state_r;
  
  logic [3:0] cntr;

  logic [7:0] data_r;
  
  logic edge_reg;

  always_ff @(posedge clk or posedge rst) begin

    if(rst) begin

      state_r <= IDLE;
      data_out <= 1'b1;
      data_in_ready <= 1'b0;
      baudclk_en_n <= 1'b1;
      edge_reg <= '0;
      cntr <= '0;

    end else begin

    edge_reg <= baud_tick_r;


    case (state_r)
    
      IDLE: begin

        if (data_in_valid) begin 

          data_in_ready <= 1'b0;

          data_r <= data;

          state_r <= START;

          baudclk_en_n <= 1'b0;
          
        
        end else begin

          data_out <= 1'b1;

          data_in_ready <=1'b1;

          baudclk_en_n <= 1'b1;

        end

      end

      START: begin

          if(baud_tick_r > edge_reg) begin 
            
            state_r <= TX;
            data_out <= 1'b0;

          end
        end
      


      TX: begin

        if(baud_tick_r > edge_reg) begin

          data_out <= data_r[0];

          data_r <= data_r >> 1;

          cntr <= cntr + 1'b1;

            if(cntr == 4'b1000) begin 
              state_r <= IDLE;
              data_out <= 1'b1;
              cntr <= '0;
            end
        end
        

      end


    endcase

  end
end

endmodule



// module uart_rx #(
//   parameter int baudrate = 115200,
//   parameter int clkHz = 100_000_000   
// )
// (
//   input logic clk,
//   input logic rst,
//   input logic baud_tick_r,
//   output logic [7:0] data,
//   output logic data_out,
//   input logic data_in_ready,
//   input logic baudclk_en_n
// );

//   typedef enum logic [1:0] { 
//     IDLE,
//     START,
//     RX,
//     XXX = 'x

//   } state_t;

//     state_t state_r;
  
//   logic [3:0] cntr;

//   logic [7:0] data_r;
  
//   logic edge_reg;

//   always_ff @(posedge clk or posedge rst) begin

//     if(rst) begin

//       state_r <= IDLE;
//       data_out <= 1'b1;
//       data_in_ready <= 1'b0;
//       baudclk_en_n <= 1'b1;
//       edge_reg <= '0;
//       cntr <= '0;

//     end else begin

//     edge_reg <= baud_tick_r;


//     case (state_r)
    
//       IDLE: begin

//       end

//       START: begin

//         end
      
//       RX: begin

//       end


//     endcase

//   end
// end

// endmodule


module test #()
(
  input logic clk,
  output logic data_out

 );

 baud_tick baud_gen (
  .clk(clk),
  .rst(baud_rst),
  .baud_clk(baud_tick)
 );

 
 uart_tx uart_test (
  .clk(clk),
  .rst(1'b0),
  .baud_tick_r(baud_tick),
  .data(8'h3C),
  .data_in_valid(1'b1),
  .data_out(data_out),
  .data_in_ready(),
  .baudclk_en_n(baud_rst)
 );


endmodule