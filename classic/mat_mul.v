`include "row_col.v"

module mat_mul #(
    parameter width = 32,
    parameter n = 3
) (
    input clk,
    input rst, 
    input start, 
    input [n*n*width - 1 : 0] a,
    input [n*n*width - 1 : 0] b,
    output [n*n*width - 1 : 0] c,
    output done
);

 wire [width - 1 : 0] c_reg [0:n][0:n];  
 wire [n*n - 1 : 0] done_reg; 

genvar i, j, k;

generate
    for (i = 0 ; i < n ; i = i + 1) begin
        for (j = 0 ; j < n ; j = j + 1) begin
            wire [width*n -1 : 0] a_row, b_col;

            for (k = 0; k < n ; k = k + 1) begin
                assign a_row[(k+1)*width - 1 -: width] = a[(i*n + k)*width +: width];
                assign b_col[(k+1)*width - 1 -: width] = b[(k*n + j)*width +: width];
            end

            row_col #(
                .width(width),
                .n(n)
            ) uut (
                .clk(clk),
                .rst(rst),
                .start(start),
                .a(a_row),
                .b(b_col),
                .c(c_reg[i][j]),
                .done(done_reg[i*n + j])
            );
            assign c [(i*n + j)*width +: width] = c_reg[i][j];  
        end
    end
endgenerate

assign done = &done_reg;

endmodule