module tb;

    reg clk = 0;

    wire we;
    wire [31:0] addr;
    wire [31:0] wdata;
    wire [31:0] rdata;

    cpu u_cpu(clk, we, addr, wdata, rdata);
    ram u_ram(clk, we, addr, wdata, rdata);
    uart u_uart(clk, we, addr, wdata);

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);

        #200 $finish;
    end

endmodule
