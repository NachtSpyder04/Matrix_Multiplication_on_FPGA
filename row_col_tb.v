module row_col_tb();

parameter width = 32;
parameter n = 3;

reg clk;
reg rst;
reg start;
reg [width*n - 1 : 0] a;
reg [width*n - 1 : 0] b;
wire [width - 1 : 0] c;
wire done;


integer start_time, end_time;

row_col uut (.clk(clk), .rst(rst), .start(start), .a(a), .b(b), .c(c), .done(done));

initial begin
    clk = 0;
    start = 0;
    $dumpvars(0, row_col_tb);
    $dumpfile("dump.vcd");
end

always #5 clk = ~clk;

initial begin

    a = {32'd1, 32'd2, 32'd3, 32'd4, 32'd5, 32'd6, 32'd7, 32'd8, 32'd9, 32'd10};
    b = {32'd10, 32'd9, 32'd8, 32'd7, 32'd6, 32'd5, 32'd4, 32'd3, 32'd2, 32'd1};

    start = 1;
    #20;
    start = 0;

     // Capture the start time
    start_time = $time;
    
    // Wait for the computation to complete
    wait(done);
    
    // Capture the end time
    end_time = $time;
    
    // Calculate and display the elapsed time
    $display("Test Case 1: Sum of products = %d", c);
    $display("Time taken for computation: %0d ns", end_time - start_time);

    #10;
    $finish;


end

endmodule