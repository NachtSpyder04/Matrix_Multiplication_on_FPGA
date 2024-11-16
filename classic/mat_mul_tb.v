module mat_mul_tb;
    parameter width = 32;
    parameter n = 3;

    reg clk;
    reg rst;
    reg start;
    reg [n*n*width - 1 : 0] a;
    reg [n*n*width - 1 : 0] b; 
    wire [n*n*width - 1 :0] c;
    wire done;

mat_mul #(.width(width), .n(n)) uut ( .clk(clk), .rst(rst),.start(start), .a(a), .b(b), .c(c), .done(done));

reg [width - 1: 0] c_result [0:n][0:n];

task calc_c_result;
    integer i, j, k;
    begin
        for (i = 0;i < n ; i = i + 1) begin
            for (j = 0; j < n ; j = j + 1) begin
                c_result[i][j] = 0;
                for (k = 0; k < n; k = k + 1) begin
                     c_result[i][j] = c_result[i][j] + (a[(i*n + k)*width +: width] * b[(k*n + j)*width +: width]);
                end
            end
        end
    end

endtask

 always #5 clk = ~clk;  // 10ns clock period
    

integer start_time, end_time;

initial begin
    $dumpfile("mat_mul.vcd");
    $dumpvars(0, mat_mul_tb);

    clk = 0;
    rst = 0;
    start = 0;
    a = 0;
    b = 0;

    rst = 1;
    #20;
    rst = 0;

     a = {32'd1, 32'd2, 32'd3,  
             32'd4, 32'd5, 32'd6,
             32'd7, 32'd8, 32'd9};

        b = {32'd9, 32'd8, 32'd7,
             32'd6, 32'd5, 32'd4,
             32'd3, 32'd2, 32'd1};


        start_time = $realtime;
        start = 1;
        #10;
        start = 0;

         calc_c_result();

        // Wait for multiplication to complete
        wait(done);
        #100;
        $display("Multiplication completed");
        end_time = $realtime;
        $display("Time taken: %0d ns", end_time - start_time);
        
        // Verify the result using assertions
        for (integer i = 0; i < n; i = i + 1) begin
            for (integer j = 0; j < n; j = j + 1) begin
                if (c[(i*n + j)*width +: width] !== c_result[i][j]) begin
                    $display("Error: c[%0d][%0d] = %0d, expected = %0d", i, j, c[(i*n + j)*width +: width], c_result[i][j]);
                    $fatal;
                end else begin
                    $display("c[%0d][%0d] = %0d", i, j, c[(i*n + j)*width +: width]);
                end
            end
        end

        $display("Test passed");
        $finish;



end

endmodule