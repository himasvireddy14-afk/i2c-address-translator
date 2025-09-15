module testbench;
  reg clk;
  reg rst_n;
  reg scl_in;
  wire scl_out;
  wire sda_out;
  wire sda_in;
  i2c_addr_translator #(
    .OLD_ADDR(7'h48),
    .NEW_ADDR(7'h49)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .scl_in(scl_in),
    .sda_in(sda_in),
    .scl_out(scl_out),
    .sda_out(sda_out)
  );
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  initial begin
    rst_n = 0;
    scl_in = 0;
    #20 rst_n = 1;
    repeat (20) begin
      #10 scl_in = ~scl_in;
    end

    #200 $finish;
  end
  initial begin
    $dumpfile("dump.vcd");   
    $dumpvars(0, testbench);
  end
endmodule
