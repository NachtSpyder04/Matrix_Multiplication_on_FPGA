module pe (
    input clk,
    input reset,
    input  [15:0] data_in_a,
    input [15:0] data_in_1,
    output reg [15:0] data_out_a,
    output reg[15:0] data_out_1,
    output reg [31:0] result
);

always @(posedge clk) begin
    if (reset) begin
        data_out_a <= 0;
        data_out_1 <= 0;
        result <= 0;
    end
    else begin
        result <= result + (data_in_a * data_in_1);
        data_out_1 <= data_in_1;
        data_out_a <= data_in_a;
    end
end

endmodule