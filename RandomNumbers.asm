# the random number generator will follow the Linear Congruential Method, where a = 30, X0 = 5000, c = 1889, and m = 90000
# In other words:
#	X(n+1) = (a(Xn) + c) % m

main:
	addi $t0, $zero, 30	# test code designed to get 10 instances of a random number; naturally, this can go 
	# ********* NOTE: The following declarations should probably be moved into the main method, or else the program will load them into memory every time this method is called ********** #
	li $t9, 10000 	# the remainder will be divided by 10000 to get a number between 0 and 8
	li $s7, 50000	# the current instance of the method, Xn, will be kept in s7
	li $s4, 61	# store a in s4
	li $s5, 3571	# store c in s5
	li $s6, 90000	# store m in s6
	# ********** OK, you can stop moving things into the main method now.  That's all I needed. ********** #
	
RandomNumberGenerator:
	
	# So, the way this method works is that it multiplies a by Xn, adds c to that, and gets the remainder of that mess all divided by m.
	# Then I come along and divide the remainder by 10000 to get it within the range we want.
	# The final random number generated will be found in t8.  Note that t8 can be overwritten as soon as you have the number you want; just don't store anything in there you want to keep.
	
	mul $s7, $s7, $s4
	add $s7, $s7, $s5
	div $s7, $s6 
	mfhi $s7
	add $t8, $s7, $zero
	div $t8, $t8, $t9
	mflo $t8
	addi $t8, $t8, 1
	
	# print out the random number to verify that the thing works; this can go once the code has actually been worked into the generator
	
	move $a0, $t8
	li $v0, 1
	syscall
	
	addi $t0, $t0, -1
	bne $t0, $zero, RandomNumberGenerator

End:
	li $v0, 10
	syscall
	
