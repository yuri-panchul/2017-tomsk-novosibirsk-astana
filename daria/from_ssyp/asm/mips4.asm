li $t0, 0x10010000
addiu $t1, $t0, 0x100
li $t2, 0
Loop: 
	sw $t2, ($t0)
	addiu $t0, $t0, 4
	bne $t0, $t1, Loop
	addiu $t2, $t2, 1