`timescale 1ns / 1ps

module sys_array_tb;
    // Testbench variables
    reg clk;
    reg reset;
    reg [143:0] data_in_a;     // Flattened 1D array of input data (3x3, 16-bit values each)
    reg [143:0] data_in_1;     // Flattened 1D array of kernel values (3x3, 16-bit values each)
    wire [31:0] result;        // Output result from the systolic array

    // Instantiate the sys_array module
    sys_array uut (
        .clk(clk),
        .reset(reset),
        .data_in_a(data_in_a),
        .data_in_1(data_in_1),
        .result(result)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns period clock
    end

    // VCD Dumping for GTKWave
    initial begin
        $dumpfile("sys_array_tb.vcd");   // Specify the VCD file name
        $dumpvars(0, sys_array_tb);      // Dump all variables in this module
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        
        // Define flattened input data and kernel values (3x3 matrix, each element 16 bits)
        // These represent a 3x3 matrix, flattened into a 1D array of 16-bit elements
        data_in_a = {16'd1, 16'd2, 16'd3, 
                     16'd4, 16'd5, 16'd6,
                     16'd7, 16'd8, 16'd9};

        data_in_1 = {16'd1, 16'd0, -16'd1,
                     16'd1, 16'd0, -16'd1,
                     16'd1, 16'd0, -16'd1};

        // Apply reset
        #10 reset = 0; // Release reset after 10ns

        // Wait for the computation to complete
        #100;

        // Display the result
        $display("Convolution Result: %d", result);

        // End simulation
        #10 $finish;
    end
endmodule
