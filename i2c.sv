// i2c.sv
// Starter SystemVerilog code for an I2C module

module i2c #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 7
)(
    input  logic                  clk,       // Clock signal
    input  logic                  rst,       // reset
    input  logic                  start,     // Start signal
    input  logic [ADDR_WIDTH-1:0] slave_addr,// Slave address
    input  logic [DATA_WIDTH-1:0] data_in,   // Data to be sent
    output logic [DATA_WIDTH-1:0] data_out,  // Received data
    output logic                  busy,      // Busy flag
    output logic                  ack,       // Acknowledge signal
    inout  logic                  sda,       // Serial Data Line
    output logic                  scl        // Serial Clock Line
);

    // Internal signals

    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    logic sda_direc;
    state_t state_r;
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;
    logic [DATA_WIDTH - 1 : 0] data_in_r = '0;

    always_comb begin : data_in_out

    sda = sda_direc ? data_in_r[0] : 'bz;    
        
    end
    
    // State machine (placeholder)
    always_ff @(posedge clk or posedge rst) begin
        if (!rst) begin
            state <= IDLE;
            busy  <= LOW;
            ack   <= LOW;
            data_out <= '0;
            busy <= LOW;
            sda <= LOW;
            scl <= LOW;
        end else begin
            case (state_r)
                IDLE: begin

                    ack <= LOW;
                    sda <= HIGH; 
                    scl <= HIGH; 

                    if (start) begin

                        state_r <= START;
                        busy      <= HIGH;
                        sda       <= LOW;
                        data_in_r <= data_in;
                        sda_direc <= HIGH;
                        state <= START;

                    end
                end
                START: begin
                    // transmit address wait for ack then transmit data
                    state_r <= DATA;
                end
                DATA: begin
                    // Implement data transmission/reception
                    state_r <= STOP;
                end
                STOP: begin
                    // Implement stop condition
                    state_r <= IDLE;
                    busy      <= 0;
                end
                default: state_reg <= IDLE;
        end
    end

    // Add I2C protocol logic here

endmodule