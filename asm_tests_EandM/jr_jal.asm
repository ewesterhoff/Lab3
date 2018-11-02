li $sp 0x3ffc

addi $t0, $zero, 10
addi $t1, $zero, 21
addi $t2, $zero 31

jal silly 
addi $t3, $zero, 10

silly: add $t4,$t0,$t1
sub $t3,$t2,$t0
jr $ra