#### How to compile and run testbenches

##### Note: assembly tests have already been compiled. They can be recompiled by running ```make``` in /asm_tests_EandM

##### ADDI
Tests add immediate, branch if equal, jum
```
iverilog -o addi_cpu_test.t addi_cpu_test.t.v
```

##### JR_JAL
Tests jump register and jump and link
```
iverilog -o jr_jal_cpu_test.t jr_jal_cpu_test.t.v
```

##### LW_SW
Tests load and store word
```
iverilog -o lw_sw_cpu_test.t lw_sw_cpu_test.t.v
```

##### XOR_ETC
Tests add, subtract, xor immediate and set less than
```
iverilog -o xor_etc_cpu_test.t xor_etc_cpu_test.t.v
```

##### MIRROR
Expanded our understanding of assembly
```
iverilog -o mirror_cpu_test.t mirror_cpu_test.t.v
```
