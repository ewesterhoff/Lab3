li $sp 0x3ffc

la 	$t1, my_array
		
addi	$t0, $zero, 1439	
sw	$t0, 0($t1)
lw 	$t3, 0($t1)	


.data 
my_array: