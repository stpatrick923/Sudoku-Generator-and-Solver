.data

FirstPuzzle: 
	.word 1, 2, 3, 4, 5, 6, 7, 8, 9, 4, 5, 6, 7, 8, 9, 1, 2, 3, 7, 8, 9, 1, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 7, 8, 9, 1, 5, 6, 7, 8, 9, 1, 2, 3, 4, 8, 9, 1, 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7, 8, 9, 1, 2, 6, 7, 8, 9, 1, 2, 3, 4, 5, 9, 1, 2, 3, 4, 5, 6, 7, 8

.text

main:
	la $t0, FirstPuzzle
	li $t1, 0
	# ********* NOTE: The following declarations should probably be moved into the main method, or else the program will load them into memory every time this method is called ********** #
	li $t9, 10000 	# the remainder will be divided by 10000 to get a number between 0 and 8
	li $s7, 50000	# the current instance of the method, Xn, will be kept in s7
	li $s4, 61	# store a in s4
	li $s5, 3571	# store c in s5
	li $s6, 90000	# store m in s6
	# ********** OK, you can stop moving things into the main method now.  That's all I needed. ********** #
	
# generate a random number.  If that number is under 5, write a zero to that location and move to the next number.  Otherwise, just move to the next number
RandomGeneration:
	beq $t1, 81, PrintArray
	mul $s7, $s7, $s4
	add $s7, $s7, $s5
	div $s7, $s6 
	mfhi $s7
	add $t8, $s7, $zero
	div $t8, $t8, $t9
	mflo $t8
	addi $t8, $t8, 1

	addi $t1, $t1, 1	# increment t1
	
	move $a0, $t8
	li $v0, 1
	syscall
	
	bgt $t8, 4, DoNothing
	j WriteZero
	
DoNothing:
	addi $t0, $t0, 4
	j RandomGeneration

WriteZero:
	li $t4, 0
	sw $t4, ($t0)
	addi $t0, $t0, 1
	j RandomGeneration

PrintArray:
	subi $t0, $t0, 324
	add $t1, $zero, $zero
	Loop: 	beq $t1, 81, Terminate
		lw $t4, ($t0)
		move $a0, $t4
		li $v0, 1
		syscall
		
		j Loop
	
Terminate:
	li $v0, 10
	syscall