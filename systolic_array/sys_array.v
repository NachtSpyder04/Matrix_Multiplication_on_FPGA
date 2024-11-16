
module sys_array (
    input clk,
    input reset,
    input [143:0] data_in_1 ,
    input [143:0] data_in_a ,
    output [31:0] result
);

wire [31:0] pe_result [8:0];
wire [15:0] data_out_a [8:0];    
wire [15:0] data_out_1 [8:0];

genvar i, j;
    generate
        for (i = 0; i < 3; i = i + 1) begin 
            for (j = 0; j < 3; j = j + 1) begin 
               
                localparam  idx = i * 3 + j;
                pe pe1 (
                    .clk(clk),
                    .reset(reset),
                    .data_in_a((i == 0) ? data_in_a[idx*16 +: 16] : data_out_a[idx - 3]), 
                    .data_in_1((j == 0) ? data_in_1[idx*16 +: 16] : data_out_1[idx - 1]), 
                    .data_out_a(data_out_a[idx]),
                    .data_out_1(data_out_1[idx]),
                    .result(pe_result[idx])
                );
            end
        end
    endgenerate

assign result = pe_result[0] + pe_result[1] + pe_result[2] + pe_result[3] + pe_result[4] + pe_result[5] + pe_result[6] + pe_result[7] + pe_result[8];


endmodule