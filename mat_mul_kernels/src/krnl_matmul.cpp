#include <stdint.h>
#include <hls_stream.h>

#define MAT_SIZE 16

// TRIPCOUNT identifier
const int c_size = MAT_SIZE;


static void row_col(uint32_t* in1, uint32_t* in2, uint32_t* out ){

	int A[MAT_SIZE*MAT_SIZE] = {0};
	int B[MAT_SIZE*MAT_SIZE] = {0};
	int C[MAT_SIZE*MAT_SIZE] = {0};


	READ:
	for (int i = 0; i<MAT_SIZE; i++){
#pragma HLS PIPELINE II = 1
		for (int j = 0; j<MAT_SIZE; j++){
				#pragma HLS UNROLL

				A[i*MAT_SIZE + j] = in1[i*MAT_SIZE + j];
				B[i*MAT_SIZE + j] = in2[i*MAT_SIZE + j];
			}
	}

	ROW:
	for (int i = 0; i < MAT_SIZE; i++){
#pragma HLS PIPELINE II = 1
		COL:
		for (int j = 0; j < MAT_SIZE; j++){
				COMPUTE:
				for (int k = 0; k < MAT_SIZE; k++){
					#pragma HLS UNROLL
					C[i*MAT_SIZE + j] = C[i*MAT_SIZE + j] + A[i*MAT_SIZE + k] * B[k*MAT_SIZE + j];

				}

			}
	}

	WRITE:
		for (int i = 0; i<MAT_SIZE; i++){
#pragma HLS PIPELINE II = 1
			for (int j = 0; j<MAT_SIZE; j++){
					#pragma HLS UNROLL
					out[i*MAT_SIZE + j] = C[i*MAT_SIZE + j];

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
