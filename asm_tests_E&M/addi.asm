# Initialize variables
addi	$t0, $zero, 2		# i, the current array element being accessed
addi	$t1, $zero, 3		# address of my_array[i] (starts from base address for i=0)

LOOPSTART:
beq 	$t0, $t1, LOOPEND
addi	$t0, $t0, 1
j	LOOPSTART		# GOTO start of loop
LOOPEND:
j	LOOPEND			# Jump trap prevents falling off end of program

