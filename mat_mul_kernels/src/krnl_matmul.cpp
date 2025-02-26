#include <stdint.h>
#include <hls_stream.h>

#define MAT_SIZE 16
#define TILE_SIZE 4

// TRIPCOUNT identifier
const int c_size = MAT_SIZE;


static void row_col(uint32_t* in1, uint32_t* in2, uint32_t* out ){

	  int A[TILE_SIZE][TILE_SIZE] = {0};
	#pragma HLS ARRAY_PARTITION variable=A complete dim=2
	    int B[TILE_SIZE][TILE_SIZE] = {0};
	#pragma HLS ARRAY_PARTITION variable=A complete dim=2
	    int C[TILE_SIZE][TILE_SIZE] = {0};
	#pragma HLS ARRAY_PARTITION variable=A complete dim=2

TILE:
for (int a = 0; a < MAT_SIZE; a+=TILE_SIZE){
#pragma HLS PIPELINE II = 1
	for (int b = 0; a < MAT_SIZE; b+=TILE_SIZE) {

	READ:
	for (int i = 0; i<TILE_SIZE; i++){
#pragma HLS PIPELINE II = 1
		for (int j = 0; j<TILE_SIZE; j++){
				#pragma HLS UNROLL

				A[i][j] = in1[(a+i)*MAT_SIZE + (b+j)];
				B[i][j] = in2[(a+i)*MAT_SIZE + (b+j)];
			}
	}

	ROW:
	for (int i = 0; i < TILE_SIZE; i++){
#pragma HLS PIPELINE II = 1
		COL:
		for (int j = 0; j < TILE_SIZE; j++){
				COMPUTE:
				for (int k = 0; k < TILE_SIZE; k++){
					#pragma HLS UNROLL
					C[i][j] = C[i][j] + A[i][k] * B[k][j];

				}

			}
	}

	WRITE:
		for (int i = 0; i<TILE_SIZE; i++){
#pragma HLS PIPELINE II = 1
			for (int j = 0; j<TILE_SIZE; j++){
					#pragma HLS UNROLL
					out[(a+i)*MAT_SIZE + (b+j)] = C[i][j];

				}
		}
	}
}

}

extern "C" {


void krnl_matmul(uint32_t* in1, uint32_t* in2, uint32_t* out) {
#pragma HLS INTERFACE m_axi port = in1 bundle = gmem0
#pragma HLS INTERFACE m_axi port = in2 bundle = gmem1
#pragma HLS INTERFACE m_axi port = out bundle = gmem0


#pragma HLS dataflow

	  row_col(in1, in2, out);
}
}
