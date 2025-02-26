module row_col #(
    parameter width = 32,
    parameter n = 3
) (
    input clk,
    input rst,
    input start,
    input [width*n - 1 : 0] a,
    input [width*n - 1 : 0] b,
    output reg [width - 1 : 0] c,
    output reg done
);
    
localparam idle = 2'b00, calc = 2'b01, out = 2'b10;

reg [1:0] state = idle;
reg [n-1:0] j = 0;
reg [width - 1 : 0] sum = 0;

always @(posedge clk ) begin
    if (rst) begin
        state <= idle;
        j <= 0;
        sum <= 0;
        done <= 0;
        c <= 0;
    end
    else begin
        case (state)
            idle: begin
                if (start) begin
                    state <= calc;
                    j <= 0;
                    sum <= 0;
                    c <= 0;
                    done <= 0;
                end
            end 
            calc: begin
                if ( j < n-1) begin
                    sum <= sum + ( a[j*width +: width] * b[j*width +: width]);
                    j <= j + 1;
                end
                else begin
                     sum <= sum + ( a[j*width +: width] * b[j*width +: width]);
                     state <= out;
                end
            end
            out: begin
                done <= 1;
                state <= idle;
                c <= sum;
            end
            default: ;
        endcase
    end
end

endmodule