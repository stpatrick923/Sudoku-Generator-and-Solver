# the random number generator will follow the Linear Congruential Method, where a = 30, X0 = 5000, c = 1889, and m = 90000
# In other words:
#	X(n+1) = (a(Xn) + c) % m

# The puzzle's difficulty will be stored in t2.
.data

AskFirstValue:
	.asciiz "Enter a random value between 1000 and 99999\n"

AskSecondValue:
	.asciiz "Enter another number between 1000 and 99999.  These will be used to seed the random number generator.\n"

AskDifficulty:
	.asciiz "Enter a value between 1 and 9.  This will determine how hard the final puzzle is.  So no pressure or anything.  (Numbers under 1 will return a solved board; anything above 9 will return a blank board)\n"

MeaningOfEverything:
	.asciiz "Life, the universe, and everything.  But not an acceptable value.  Now how about entering a value between 1000 and 99999?  Go with 4242 if you really insist.\n"
	
Jackpot:
	.asciiz "Jackpot!  COngratulations, kid!  ...But you still need a number between 1000 and 99999, and a jackpot doesn't cut it.  Enter a number between 1000 and 99999.\n"
	
Blackjack:
	.asciiz "I'd yell out 'Blackjack!', but considering that's not a valid number you haven't won squat.  Enter a number between 1000 and 99999, high roller.\n"

TheDevil:
	.asciiz "Yeah, yeah, number of the beast and all that.  I don't care if you're the devil himself, I still need a number between 1000 and 99999.  Just try not to fry anything in the process.\n"

SecondMistakeAgain:
	.asciiz "Oh Jesus, not this crap again.  Look...could you just enter a number between 1000 and 99999?\n"

FirstMistake:
	.asciiz "Enter a number between 1000 and 99999, stupid.\n"

SecondMistake:
	.asciiz "You got a problem reading?  Enter a number between 1000 and 99999.\n"

ThirdMistake:
	.asciiz "<Sigh> If your IQ weren't clearly lower than my size in kilobytes, I would think you were trying to annoy me.  Now, please enter a number between 1000 and 99999.\n"
	
FourthMistake:
	.asciiz "You know what?  I have no time for such nonsense.  Run me again once you've gotten your act together.\n"

.text

main:
	addi $t0, $zero, 40	# test code designed to get 10 instances of a random number; naturally, this can go 
	add  $t1, $zero, $zero  # keeps track of how many errors the user has made, so that the program can quit if one of the specific error messages is given.  Note that t1 will be free after we're done seeding the generator.
	
GetFirstValue:	
	la $a0, AskFirstValue
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# check that the user entered an appropriate value.  If they didn't, chastise them.
	
	beq $v0, 777, ChastiseJackpot
	beq $v0, 42, ChastiseEverything
	beq $v0, 666, ChastiseDevil
	beq $v0, 21, ChastiseBlackjack
	blt $v0, 1000, ChastiseOnceFirst
	bgt $v0, 99999, ChastiseOnceFirst
	
	move $s0, $v0
	
GetSecondValue:
	la $a0, AskSecondValue
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $t1, $zero, NoPriors
		beq $v0, 21, ChastiseBlackjackSecond
	beq $v0, 42, ChastiseEverythingSecond
	beq $v0, 666, ChastiseDevilSecond
	beq $v0, 777, ChastiseJackpotSecond
	blt $v0, 1000, ChastiseSecondPrior
	bgt $v0, 99999, ChastiseSecondPrior
	# check that the user entered an appropriate value.  If they didn't, chastise them.
	
NoPriors:
		beq $v0, 21, ChastiseBlackjack
		beq $v0, 42, ChastiseEverything
		beq $v0, 666, ChastiseDevil
		beq $v0, 777, ChastiseJackpot
		blt $v0, 1000, ChastiseOnceSecond
		bgt $v0, 99999, ChastiseOnceSecond
	
		move $s7, $v0

ValuesGotten:	
	# ********* NOTE: The following declarations should probably be moved into the main method, or else the program will load them into memory every time this method is called ********** #
	li $t9, 10000 		# the remainder will be divided by 10000 to get a number between 0 and 8
	add $s7, $s7, $s0	# the current instance of the method, Xn, will be kept in s7
	li $s4, 61		# store a in s4
	li $s5, 3571		# store c in s5
	li $s6, 90000		# store m in s6
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

# down here, we have all the methods for berating the user if they didn't enter an appropriate value at the start of the program.

ChastiseOnceFirst:
	addi $t1, $t1, 1
	la $a0, FirstMistake
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
		beq $v0, 21, ChastiseBlackjack
	beq $v0, 42, ChastiseEverything
	beq $v0, 666, ChastiseDevil
	beq $v0, 777, ChastiseJackpot
	blt $v0, 1000, ChastiseTwiceFirst
	bgt $v0, 99999, ChastiseTwiceFirst
	
	move $s0, $v0
	j GetSecondValue

ChastiseTwiceFirst:
	addi $t1, $t1, 1
	la $a0, SecondMistake
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# check that the user entered an appropriate value.  If they didn't, chastise them.
		beq $v0, 21, ChastiseBlackjack
	beq $v0, 42, ChastiseEverything
	beq $v0, 666, ChastiseDevil
	beq $v0, 777, ChastiseJackpot
	blt $v0, 1000, ChastiseThriceFirst
	bgt $v0, 99999, ChastiseThriceFirst
	
	move $s0, $v0
	j GetSecondValue
	
ChastiseThriceFirst:
	addi $t1, $t1, 1
	la $a0, ThirdMistake
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# check that the user entered an appropriate value.  If they didn't, chastise them.
		beq $v0, 21, ChastiseBlackjack
	beq $v0, 42, ChastiseEverything
	beq $v0, 666, ChastiseDevil
	beq $v0, 777, ChastiseJackpot
	blt $v0, 1000, GiveUp
	bgt $v0, 99999, GiveUp
	
	move $s0, $v0
	j GetSecondValue

ChastiseOnceSecond:
	addi $t1, $t1, 1
	la $a0, FirstMistake
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# check that the user entered an appropriate value.  If they didn't, chastise them.
		beq $v0, 21, ChastiseBlackjackSecond
	beq $v0, 42, ChastiseEverythingSecond
	beq $v0, 666, ChastiseDevilSecond
	beq $v0, 777, ChastiseJackpotSecond
	blt $v0, 1000, ChastiseTwiceSecond
	bgt $v0, 99999, ChastiseTwiceSecond
	
	move $s7, $v0
	j ValuesGotten

ChastiseTwiceSecond:	
	addi $t1, $t1, 1
	la $a0, SecondMistake
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# check that the user entered an appropriate value.  If they didn't, chastise them.
		beq $v0, 21, ChastiseBlackjackSecond
	beq $v0, 42, ChastiseEverythingSecond
	beq $v0, 666, ChastiseDevilSecond
	beq $v0, 777, ChastiseJackpotSecond
	blt $v0, 1000, ChastiseThriceSecond
	bgt $v0, 99999, ChastiseThriceSecond
	
	move $s7, $v0
	j ValuesGotten

ChastiseThriceSecond:	
	addi $t1, $t1, 1
	la $a0, ThirdMistake
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# check that the user entered an appropriate value.  If they didn't, chastise them.
	beq $v0, 21, ChastiseBlackjackSecond
	beq $v0, 42, ChastiseEverythingSecond
	beq $v0, 666, ChastiseDevilSecond
	beq $v0, 777, ChastiseJackpotSecond
	blt $v0, 1000, GiveUp
	bgt $v0, 99999, GiveUp
	
	move $s7, $v0
	j ValuesGotten
	
ChastiseSecondPrior:
	addi $t1, $t1, 1
	la $a0, SecondMistakeAgain
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 21, ChastiseBlackjackSecond
	beq $v0, 42, ChastiseEverythingSecond
	beq $v0, 666, ChastiseDevilSecond
	beq $v0, 777, ChastiseJackpotSecond
	blt $v0, 1000, ChastiseTwiceSecond
	bgt $v0, 99999, ChastiseTwiceSecond
	
	move $s7, $v0
	j ValuesGotten
	
ChastiseBlackjack:
	addi $t1, $t1, 1
	la $a0, Blackjack
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 21, ChastiseBlackjack
	beq $v0, 42, ChastiseEverything
	beq $v0, 666, ChastiseDevil
	beq $v0, 777, ChastiseJackpot
	blt $v0, 1000, HowManyErrors
	blt $v0, 99999, HowManyErrors
	
	move $s0, $v0
	j GetSecondValue
	
HowManyErrors:
	beq $t1, 1, ChastiseOnceFirst
	beq $t1, 2, ChastiseTwiceFirst
	beq $t1, 3, ChastiseThriceFirst
	j GiveUp
		
ChastiseEverything:
	addi $t1, $t1, 1
	la $a0, MeaningOfEverything
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 21, ChastiseBlackjack
	beq $v0, 42, ChastiseEverything
	beq $v0, 666, ChastiseDevil
	beq $v0, 777, ChastiseJackpot
	blt $v0, 1000, HowManyErrors
	blt $v0, 99999, HowManyErrors
	
	move $s0, $v0
	j GetSecondValue

		
ChastiseDevil:
	addi $t1, $t1, 1
	la $a0, TheDevil
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 21, ChastiseBlackjack
	beq $v0, 42, ChastiseEverything
	beq $v0, 666, ChastiseDevil
	beq $v0, 777, ChastiseJackpot
	blt $v0, 1000, HowManyErrors
	blt $v0, 99999, HowManyErrors
	
	move $s0, $v0
	j GetSecondValue
	
ChastiseJackpot:
	addi $t1, $t1, 1
	la $a0, Jackpot
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 21, ChastiseBlackjack
	beq $v0, 42, ChastiseEverything
	beq $v0, 666, ChastiseDevil
	beq $v0, 777, ChastiseJackpot
	blt $v0, 1000, HowManyErrors
	blt $v0, 99999, HowManyErrors
	
	move $s0, $v0
	j GetSecondValue
	
ChastiseBlackjackSecond:
	addi $t1, $t1, 1
	la $a0, Blackjack
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 21, ChastiseBlackjackSecond
	beq $v0, 42, ChastiseEverythingSecond
	beq $v0, 666, ChastiseDevilSecond
	beq $v0, 777, ChastiseJackpotSecond
	blt $v0, 1000, HowManyErrors2
	blt $v0, 99999, HowManyErrors2
	
	move $s7, $v0
	j ValuesGotten
	
HowManyErrors2:
	beq $t1, 1, ChastiseOnceSecond
	beq $t1, 2, ChastiseTwiceSecond
	beq $t1, 3, ChastiseThriceSecond
	j GiveUp
	
ChastiseEverythingSecond:
	addi $t1, $t1, 1
	la $a0, MeaningOfEverything
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 21, ChastiseBlackjackSecond
	beq $v0, 42, ChastiseEverythingSecond
	beq $v0, 666, ChastiseDevilSecond
	beq $v0, 777, ChastiseJackpotSecond
	blt $v0, 1000, HowManyErrors2
	blt $v0, 99999, HowManyErrors2
	
	move $s7, $v0
	j ValuesGotten
	
ChastiseDevilSecond:
		addi $t1, $t1, 1
	la $a0, TheDevil
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 21, ChastiseBlackjackSecond
	beq $v0, 42, ChastiseEverythingSecond
	beq $v0, 666, ChastiseDevilSecond
	beq $v0, 777, ChastiseJackpotSecond
	blt $v0, 1000, HowManyErrors2
	blt $v0, 99999, HowManyErrors2
	
	move $s7, $v0
	j ValuesGotten
	
ChastiseJackpotSecond:
	addi $t1, $t1, 1
	la $a0, Jackpot
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 21, ChastiseBlackjackSecond
	beq $v0, 42, ChastiseEverythingSecond
	beq $v0, 666, ChastiseDevilSecond
	beq $v0, 777, ChastiseJackpotSecond
	blt $v0, 1000, HowManyErrors2
	blt $v0, 99999, HowManyErrors2
	
	move $s7, $v0
	j ValuesGotten
	
				
GiveUp:
	la $a0, FourthMistake
	li $v0, 4
	syscall
	
	j End
