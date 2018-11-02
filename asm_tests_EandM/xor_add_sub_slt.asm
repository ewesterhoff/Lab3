li $sp 0x3ffc

addi	$t0, $zero, 21		# i, the current array element being accessed
addi	$t1, $zero, 30	

add $t3, $t0, $t1	#51
sub $t4, $t0, $t1	#-9

xori $t5, $t0, 42	#21 xori 42 
xori $t6, $t0, 21	#21 xori 21

slt $t7, $t0, $t1
slt $t8 $t1, $t0