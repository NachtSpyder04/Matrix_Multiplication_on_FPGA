
SRC = mat_mul.v
TB = mat_mul_tb.v
OUT = mat_mul
DUMP = mat_mul.vcd

all: compile run view 

compile: 
	iverilog -o $(OUT) $(SRC) $(TB)

run: compile
	vvp $(OUT)

view: run
	gtkwave $(DUMP) 

.PHONY: clean

clean:
	rm -f $(OUT) $(DUMP)
