module i2c_addr_translator (
    input  wire       clk,    
    input  wire       rst_n,  
    input  wire       scl_in,  
    inout  wire       sda_in,  
    output wire       scl_out, 
    inout  wire       sda_out  
);
    parameter OLD_ADDR = 7'h48;
    parameter NEW_ADDR = 7'h49;
    reg [3:0] bit_cnt;
    reg [6:0] addr_shift;
    reg       translating;
    assign scl_out = scl_in;
    assign sda_out = (translating) ? addr_shift[6] : sda_in;
    always @(negedge scl_in or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt     <= 0;
            addr_shift  <= 0;
            translating <= 0;
        end else begin
            if (bit_cnt < 7) begin
                addr_shift <= {addr_shift[5:0], sda_in};
                bit_cnt    <= bit_cnt + 1;
            end else if (bit_cnt == 7) begin
                if (addr_shift == OLD_ADDR) begin
                    addr_shift <= NEW_ADDR;
                    translating <= 1;
                end else begin
                    translating <= 0;
                end
                bit_cnt <= bit_cnt + 1;
            end
        end
    end

endmodule
