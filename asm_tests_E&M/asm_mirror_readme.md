## Mirror Array Assembly Script

Tests addi, beq, sub, subi, lw, sw, jump

Purpose: Takes in a data file and mirrors the elements over the middle line

INPUT:
* .data
* my_array:
* 0x11110000	# my_array[0]
* 0x22220000
* 0x44440000
* 0x66660000
* 0x88880000
* 0xAAAA0000
* 0xCCCC0000
* 0xEEEE0000

EXPECTED OUTPUT:
* 0xEEEE0000
* 0xCCCC0000
* 0xAAAA0000
* 0x88880000
* 0x66660000
* 0x44440000
* 0x22220000
* 0x11110000
