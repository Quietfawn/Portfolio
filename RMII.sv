module rmii_tx#()
(
input logic rst,
input logic data_valid,
input logic [7:0] data, 
input logic clk, 
output logic tx_en,
output logic [1:0] txd,
output logic tx_rdy

);

typedef enum logic [1:0] {
        IDLE,
        START,
        TX,
        XXX = 'x

        } state_t;

state_t state_r;
logic [1:0] bit_counter;
logic [7:0] data_r;



always_ff @(posedge clk or posedge rst)

if (rst) begin
    tx_en <= '0;
    txd <= '0;
    tx_rdy <= '1;
    state_r <= IDLE;
    bit_counter <= '0;
end else begin
    begin
        case (state_r)

        IDLE:
        begin

            if(data_valid) begin
                data_r <= data;
                state_r <= TX;
                tx_rdy <= 1'b0; 
            end else begin
                txd <= '0;
                tx_en <='0;
                tx_rdy <= '1;
            end
          
        end

        START:
        begin

        end

        TX:
        begin

            tx_rdy <= 1'b1;
            tx_en <= 1'b1;
            txd <= data_r[1:0];
            data_r <= data_r >> 2;
            bit_counter <= bit_counter + 1'b1;

            if (bit_counter == '1) begin

                if (data_valid) begin
                    data_r <= data;
                    tx_rdy <= 1'b0;
                    bit_counter <= '0;
                end else state_r <= IDLE;

            end

        end
        endcase
    end

end
endmodule