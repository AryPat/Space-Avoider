######################################################################
# CSCB58 Winter2021Assembly Final Project
# University of Toronto, Scarborough## Student: Name, Student Number, UTorID
#
# Bitmap Display Configuration:
# -Unit width in pixels: 8 (update this as needed)
# -Unit height in pixels: 8 (update this as needed)
# -Display width in pixels: 256 (update this as needed)
# -Display height in pixels: 256 (update this as needed)
# -Base Address for Display: 0x10008000 ($gp)
#
# Which milestoneshave beenreached in this submission?
# (See the assignment handout for descriptions of the milestones)
# -Milestone 1/2/3/4 (choose the one the applies)
#
# Which approved features have been implementedfor milestone 4?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)#... (add more if necessary)
#
# Link to video demonstration for final submission:
# -(insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
#Are you OK with us sharing the video with people outside course staff?
# -yes / no/ yes, and please share this project githublink as well!
#
# Any additional information that the TA needs to know:
# -(write here, if any)#
#####################################################################

# Bitmap display starter code## Bitmap Display Configuration:
# -Unit width in pixels: 8
# -Unit height in pixels: 8
# -Display width in pixels: 256
# -Display height in pixels: 256
# -Base Address for Display: 0x10008000 ($gp)
#
.eqv BASE_ADDRESS 0x10008000
.eqv BLACK 0x00000000
.eqv SPACE_1 0x0000838f
.eqv SPACE_2 0x00b488ff
.eqv DARK_RED 0x00d50000
.eqv LIGHT_RED 0x00ff8b80
.eqv RED 0x00ff5252
.eqv LIGHT_BLUE 0x0000bbd4
.eqv BLUE 0x0003a8f4
.eqv DARK_BLUE 0x003f51b5
.eqv ORANGE 0x00ff9900
.eqv YELLOW 0x00ffeb3b


.data
	# stores address of ship
	shipLoco: .word 0,0,0,0,0 # top, right, bottom, left, middle 
	object: .word 0,0,0 	# first, second, third
	 				   	# Stores the head of the objects	
	

.text 

.globl main

# Change the background color to black
blackGround: 

	li $t0, BASE_ADDRESS    # Base Address
	add $t3, $t0, 4096      # Your whole Array
	li $t1, BLACK           # Store Black Color
	loop:
		bge $t0, $t3, DONE  # Loop tilt end
		sw $t1, 0($t0)      # Change pixel color to black
		add $t0, $t0, 4
		j loop
	DONE:
		jr $ra

# Start position of spaceship when game starts
startPosition:

	li $t0, BASE_ADDRESS    # Base Address
	la $t1, shipLoco        # Address of shipLocation
	li $s0, SPACE_1         # Store aqua Color
	li $s1, SPACE_2         # Store pink Color
	
	#left wing 
	add $t0, $t0, 2060      # 16(128) + 12 
	sw $s0,  0($t0) 
	sw $t0, 12($t1)
	
	#middle of ship
	add $t0, $t0, 4      # 16(128) + 12 + 4
	sw $s1,  0($t0) 
	sw $t0, 16($t1)
	
	#right of ship
	add $t0, $t0, 4      # 16(128) + 12 + 4 + 4 
	sw $s0,  0($t0) 
	sw $t0, 4($t1)
	
	#top of ship
	li $t0, BASE_ADDRESS
	add $t0, $t0, 1936      # 15(128) + 16 
	sw $s0,  0($t0) 
	sw $t0, 0($t1)
	
    #bottom of ship
    li $t0, BASE_ADDRESS
	add $t0, $t0, 2192       # 17(128) + 16 
	sw $s0,  0($t0) 
	sw $t0, 8($t1)
	
	jr $ra

BOUNDRY:
	# Print nSolutions's ANS
	#li $v0, 1
	#move $a0, $v0
	#syscall
	
	jr $ra

UP: # Cannot use $t1 here
	la $t0, shipLoco
	
	# move top of ship up 1
	lw $t2, 0($t0) # $t2 = current address of ship
	
	# To check if you are at the boundry (TOP)
	sub $t3, $t2, $t3 
	
	bge  $t3, 0, AND_UP
	AND_UP:
		ble $t3, 124, BOUNDRY

	
	
	sub $t2, $t2, 128 # $t2 = new address of ship
	sw $s0, 0($t2) # Change color in new address
	sw $t2, 0($t0) # Store new address
	
	# Repeat for the rest of the space ship part
	# move bottom of ship up 1
	lw $t2, 8($t0)
	sw $s2, 0($t2) # change old location's color 
	sub $t2, $t2, 128
	sw $s0, 0($t2)
	sw $t2, 8($t0)
	
	# move Middle of ship up 1
	lw $t2, 16($t0)
	sub $t2, $t2, 128
	sw $s1, 0($t2)
	sw $t2, 16($t0)
	
	# move left side of ship up 1
	lw $t2, 12($t0)
	sw $s2, 0($t2)
	sub $t2, $t2, 128
	sw $s0, 0($t2)
	sw $t2, 12($t0)
	
	# move right side of ship up 1
	lw $t2, 4($t0)
	sw $s2, 0($t2)
	sub $t2, $t2, 128
	sw $s0, 0($t2)
	sw $t2, 4($t0)

	jr $ra

DOWN: # Cannot use $t1 here
	la $t0, shipLoco
	
	# Repeat for the rest of the space ship part
	# move bottom of ship down 1
	lw $t2, 8($t0)
	
	# To check if you are at the boundry (BOTTOM)
	sub $t3, $t2, $t3
	
	ble  $t3, 4092, AND_DOWN
	AND_DOWN:
		bge  $t3, 3968, BOUNDRY

	sw $s1, 0($t2)
	add $t2, $t2, 128
	sw $s0, 0($t2)
	sw $t2, 8($t0)
	
	
	# move top of ship down 1
	lw $t2, 0($t0) # $t2 = current address of ship
	sw $s2, 0($t2) # chagne old location's color
	add $t2, $t2, 128 # $t2 = new address of ship
	sw $s0, 0($t2) # Change color in new address
	sw $t2, 0($t0) # Store new address
	

	# move Middle of ship down 1
	lw $t2, 16($t0)
	add $t2, $t2, 128
	sw $s1, 0($t2)
	sw $t2, 16($t0)
	
	# move left side of ship down 1
	lw $t2, 12($t0)
	sw $s2, 0($t2)
	add $t2, $t2, 128
	sw $s0, 0($t2)
	sw $t2, 12($t0)
	
	# move right side of ship up 1
	lw $t2, 4($t0)
	sw $s2, 0($t2)
	add $t2, $t2, 128
	sw $s0, 0($t2)
	sw $t2, 4($t0)

	jr $ra

LEFT: # Cannot use $t1 here

	la $t0, shipLoco
	
	# move left side of ship left 1
	lw $t2, 12($t0)	
	li $s3, 128
	div $t2, $s3
	mfhi $s3
	
	beq $s3, 0, BOUNDRY
	
	
	sw $s1, 0($t2)
	sub $t2, $t2, 4
	sw $s0, 0($t2)
	sw $t2, 12($t0)
	# move top of ship left one
	lw $t2, 0($t0) # $t2 = current address of ship
	sw $s2, 0($t2) # chagne old location's color
	sub $t2, $t2, 4 # $t2 = new address of ship
	sw $s0, 0($t2) # Change color in new address
	sw $t2, 0($t0) # Store new address
	
	# Repeat for the rest of the space ship part
	# move bottom of ship left 1
	lw $t2, 8($t0)
	sw $s2, 0($t2)
	sub $t2, $t2, 4
	sw $s0, 0($t2)
	sw $t2, 8($t0)
	
	# move Middle of ship left 1
	lw $t2, 16($t0)
	sub $t2, $t2, 4
	sw $s1, 0($t2)
	sw $t2, 16($t0)
	
	# move right side of ship up 1
	lw $t2, 4($t0)
	sw $s2, 0($t2)
	sub $t2, $t2, 4
	sw $s0, 0($t2)
	sw $t2, 4($t0)

	jr $ra
	
RIGHT: # Cannot use $t1 here
	la $t0, shipLoco
	
	# move right side of ship up 1
	lw $t2, 4($t0)
	
	move $s3, $t2
	sub $s3, $s3, 124
	li $s4, 128
	div $s3, $s4
	mfhi $s3
	
	beq $s3, 0, BOUNDRY
	

	sw $s1, 0($t2)
	add $t2, $t2, 4
	sw $s0, 0($t2)
	sw $t2, 4($t0)

	
	# move top of ship right 1
	lw $t2, 0($t0) # $t2 = current address of ship
	sw $s2, 0($t2) # chagne old location's color
	add $t2, $t2, 4 # $t2 = new address of ship
	sw $s0, 0($t2) # Change color in new address
	sw $t2, 0($t0) # Store new address
	
	# Repeat for the rest of the space ship part
	# move bottom of ship right 1
	lw $t2, 8($t0)
	sw $s2, 0($t2)
	add $t2, $t2, 4
	sw $s0, 0($t2)
	sw $t2, 8($t0)
	
	# move Middle of ship right 1
	lw $t2, 16($t0)
	add $t2, $t2, 4
	sw $s1, 0($t2)
	sw $t2, 16($t0)
	
	# move left side of ship left 1
	lw $t2, 12($t0)
	sw $s2, 0($t2)
	add $t2, $t2, 4
	sw $s0, 0($t2)
	sw $t2, 12($t0)
	

	jr $ra

keyPressed:
	lw $t0, 4($t8)
	li $t3, BASE_ADDRESS
	li $s0, SPACE_1         # Store aqua Color
	li $s1, SPACE_2         # Store pink Color
	li $s2, BLACK         # Store pink Color
	
	move $t1, $ra
	beq $t0, 119, UP #input w go up
	beq $t0, 115, DOWN #input d go up
	beq $t0, 97, LEFT #input a go left
	beq $t0, 100, RIGHT #input d go left
	move $ra, $t1
			
	beq $t0, 114, main #input P pressed
	
	jr $ra

Start:
	li $t0, BASE_ADDRESS    # Base Address
	li $t1, BASE_ADDRESS    # To Change
	
	li $s0, SPACE_1
	li $s1, SPACE_2
	
	li $t2, DARK_RED
	li $t3, LIGHT_RED
	li $t4, RED
	li $t5, DARK_BLUE
	li $t6, LIGHT_BLUE
	li $t7, BLUE
	li $t8, ORANGE
	li $t9, YELLOW
	
	# Print S
	sw $t5, 1424($t1)
	sw $t5, 1428($t1)
	sw $t6, 1432($t1)
	sw $t6, 1436($t1)
	
	sw $t6, 1308($t1)
	sw $t7, 1180($t1)
	sw $t7, 1052($t1)
	
	sw $t7, 1048($t1)

	sw $t7, 920($t1)
	sw $t6, 792($t1)
	sw $t5, 664($t1)
	
	sw $t5, 668($t1)
	sw $t5, 672($t1)
	
	# print p
	
	sw $t7, 1700($t1)
	sw $t7, 1572($t1)
	sw $t6, 1444($t1)
	sw $t6, 1316($t1)
	sw $t5, 1188($t1)
	sw $t5, 1060($t1)
	
	sw $t7, 1064($t1)
	sw $t7, 1068($t1)
	sw $t5, 1072($t1)
	
	sw $t6, 1200($t1)
	sw $t6, 1328($t1)
	
	sw $t6, 1324($t1)
	sw $t7, 1320($t1)
	# print A 
	
	sw $t7, 1592($t1)
	sw $t7, 1464($t1)
	
	sw $t7, 1336($t1)
	
	sw $s0, 1340($t1)
	sw $t7, 1344($t1)
	
	sw $s0, 1208($t1)
	
	sw $s1, 1212($t1)
	sw $s0, 1216($t1)
	
	sw $t7, 1080($t1)
	
	sw $s0, 1084($t1)
	sw $t7, 1088($t1)
	
	sw $t7, 1472($t1)
	sw $t7, 1600($t1)
	
	# Print C
	
	sw $t3, 1352($t1)
	sw $t4, 1356($t1)
	
	sw $t4, 1484($t1)
	
	sw $t4, 1488($t1)
	sw $t2, 1492($t1)
	
	sw $t3, 1096($t1)
	
	sw $t4, 968($t1)
	sw $t4, 972($t1)
	
	sw $t4, 844($t1)
	
	sw $t2, 848($t1)
	sw $t2, 852($t1)
	
	# print e
	
	sw $t5, 1500($t1)
	sw $t5, 1372($t1)
	sw $t5, 1244($t1)
	
	sw $t6, 1120($t1)
	sw $t6, 1124($t1)
	
	sw $t7, 1256($t1)
	
	sw $t7, 1380($t1)
	
	sw $t7, 1632($t1)
	sw $t7, 1636($t1)
	sw $t7, 1640($t1)
	
	sw $t7, 1640($t1)
	
	sw $t5, 1516($t1)
	
	# print quotation
	sw $t8, 2352($t1)
	sw $t8, 2228($t1)
	
	sw $t8, 2252($t1)
	sw $t8, 2384($t1)
	
	
	# print P
	sw $t9, 2492($t1)
	
	sw $t9, 2496($t1)
	sw $t9, 2500($t1)
	sw $t9, 2628($t1)
	
	sw $t9, 2620($t1)
	sw $t9, 2748($t1)
	
	sw $t9, 2752($t1)
	sw $t9, 2756($t1)
	
	sw $t9, 2876($t1)
	sw $t9, 3004($t1)

	jr $ra
	
initializeObject:

	# $a0 passed in to specify the object you initializing 0, 4 or 8
	
	li $t7, BASE_ADDRESS
	la $t0, object 	# get BASE address of Object
	li $t1, 248     # Constant
	li $t2, 128     # Constant
	li $s0, DARK_RED        # Store aqua Color
	
	add $t0, $t0, $a0
	
	# get a random int, Store it in $a0
	li $v0, 42
	li $a0, 1
	li $a1, 30
	syscall	

	# Calculate Address + 248 + $a0(128) <- Position of FIRST Space Ship
	add $t3, $t7, $t1 # Address + 248
	mul $t4, $a0, $t2 # $a0(128)
	add $t3, $t3, $t4 # Address + 251 + $a0(128)
	
	sw $t3, 0($t0) 		# Store the address of the first ship in objects
	sw $s0, 0($t3) # Change color in the board
	sw $s0, -124($t3) # Change color in the board
	sw $s0, 132($t3) # Change color in the board

	jr $ra

resetObject:
	
	move $t7, $a0
	# Print nSolutions's ANS
	li $v0, 1
	move $a0, $v0
	syscall
	
	move $a0, $t7
	
	# $a0 = Object that you need to reset 0 4 or 8 in memory
	
	li $t7, BASE_ADDRESS
	la $t0, object 				# get BASE address of Object
	li $s0, DARK_RED       
	li $s1, BLACK
	
	add $t0, $t0, $a0 			# the object you want to reset
	lw $t0, 0($t0)
	
	sw $s1, 0($t0) 				# Change color in the board
	sw $s1, -124($t0) 			# Change color in the board
	sw $s1, 132($t0) 			# Change color in the board
	
	addi $sp, $sp, -4     # Move stack pointer one word 
	sw $ra, 0($sp)        # Add $ra to the stack 
	jal initializeObject
	
	lw $ra, 0($sp)        # Load the return value
	addi $sp, $sp, 4      # Pop return value from the stack
	
	# Now that object has to have a random starting position
	
	
	
	jr $ra

moveObjectSpecific:
	
	#$a0 is the ship to be moved
	li $t7, BASE_ADDRESS
	la $t0, object 				# get BASE address of Object
	li $s0, DARK_RED       
	li $s1, BLACK
	li $s3, 128
	
	# The Specific Ship You Want to move
	add $t0, $t0, $a0
	                                #Check if you are at the border
    lw $t3, 0($t0)                 # Get the location of the ship (in general)
    sub $t3, $t3, $t7             # subtract the base location
    div $t3, $s3
    mfhi $s3
    
	addi $sp, $sp, -4     # Move stack pointer one word 
	sw $ra, 0($sp)        # Add $ra to the stack 
    beq $s3, 0, resetObject
	lw $ra, 0($sp)        # Load the return value
	addi $sp, $sp, 4      # Pop return value from the stack
	

								#else move the ships 
	lw $t3, 0($t0) 				# Get the location of object 1
								# make previos position black
	sw $s1, 0($t3) 				# Change color in the board
	sw $s1, -124($t3) 			# Change color in the board
	sw $s1, 132($t3) 			# Change color in the board
								# Change color of next position
	sub $t3, $t3, 4
	sw $t3, 0($t0)
	sw $s0, 0($t3) # Change color in the board
	sw $s0, -124($t3) # Change color in the board
	sw $s0, 132($t3) # Change color in the board

	jr $ra

moveObject:
	
	addi $sp, $sp, -4     # Move stack pointer one word 
	sw $ra, 0($sp)        # Add $ra to the stack 
	
	li $a0, 0
	jal moveObjectSpecific
	li $a0, 4
	jal moveObjectSpecific
	li $a0, 8
	jal moveObjectSpecific
	
	lw $ra, 0($sp)        # Load the return value
	addi $sp, $sp, 4      # Pop return value from the stack
	
	jr $ra
	
collisionOccured:
	addi $sp, $sp, -4     # Move stack pointer one word 
	sw $ra, 0($sp)        # Add $ra to the stack 
	
	#$a0 is the offset in object of the object that was hit by ship
	li $s4, BLACK
	add $s3, $s1, $a0 # memory address of object hit by ship
	lw $s3, 0($s3)    # location of head of object
	
	sw $s4, 0($s3)
	sw $s4, -124($s3)
	sw $s4, 132($s3)
	
	li $s5, ORANGE 
	li $t5, YELLOW
	
	move $s6, $a0
	
	lw $s7, 0($t1)
	sw $s5, 0($s7)
	
	li $v0, 32
	li $a0, 150
	syscall
	
	lw $s7, 4($t1)
	sw $s5, 0($s7)
	
	li $v0, 32
	li $a0, 150
	syscall
	
	lw $s7, 8($t1)
	sw $s5, 0($s7)
	
	li $v0, 32
	li $a0, 150
	syscall
	
	lw $s7, 12($t1)
	sw $s5, 0($s7)
	
	
	li $v0, 32
	li $a0, 150 
	syscall
	
	
	lw $s7, 16($t1)
	sw $t5, 0($s7)
	
	li $v0, 32
	li $a0, 1000 # 25 hertz Refresh rate
	syscall
	
	move $a0, $s6
	
	jal resetObject
	
	lw $ra, 0($sp)        # Load the return value
	addi $sp, $sp, 4      # Pop return value from the stack
	
	# Reset the colors on the ship to original
	li $s5, SPACE_1 
	li $t5, SPACE_2
	la $t1, shipLoco
	
	lw $s7, 0($t1)
	sw $s5, 0($s7)
	lw $s7, 4($t1)
	sw $s5, 0($s7)
	lw $s7, 8($t1)
	sw $s5, 0($s7)
	lw $s7, 12($t1)
	sw $s5, 0($s7)
	lw $s7, 16($t1)
	sw $t5, 0($s7)

	jr $ra

collision:
	addi $sp, $sp, -4     # Move stack pointer one word 
	sw $ra, 0($sp)        # Add $ra to the stack 
	
	li $t0, 0
	la $t1, shipLoco
	la $s1, object
	
	loopShipLoco:
		bge $t0, 20, leave
		add $t3, $t0, $t1
		lw $t3, 0($t3)
		li $t4, 0
		loopObject:
			bgt $t4, 8, continue
			add $s2, $s1, $t4
			lw $s2, 0($s2)
			move $a0, $t4 # keep track of which ship was hit, pass by parameter
			beq $s2, $t3, collisionOccured # Check if the head of the object matchs 
			add $s2, $s2, -124 # check if right of object was hit
			beq $s2, $t3, collisionOccured
			add $s2, $s2, 256 # check if left of object was hit
			beq $s2, $t3, collisionOccured
			add $t4, $t4, 4
			j loopObject
		
		continue: 
			add $t0, $t0, 4
		j loopShipLoco
	
	
	leave:
		lw $ra, 0($sp)        # Load the return value
		addi $sp, $sp, 4      # Pop return value from the stack
		
		jr $ra
		

main:
	
	jal blackGround
	jal Start 
	
	li $t8, 0xffff0000 		# input
	li $t1, 2 				# resetting input value
	sw $t1, 4($t8) 			# resetting input value
	
	startPage:
		lw $t0, 4($t8)
		bne $t0, 112, startPage	
	
	jal blackGround
	jal startPosition
		
	li $t9, 3                 # You have 3 lifes
	li $t7, BASE_ADDRESS
	
	# Initialize Object
	li $a0, 0
	jal initializeObject 
	li $a0, 4
	jal initializeObject 
	li $a0, 8
	jal initializeObject 
		
	
	gameLoop:
		beqz $t9, END         # If you have 0 lifes you are finished.
		lw $t0, 0($t8)
		beq $t0, 1, keyPressed
		jal collision
		jal moveObject
		
		
		li $v0, 32
		li $a0, 40 # 25 hertz Refresh rate
		syscall
		
		j gameLoop
		

END:
	li $v0, 10
	syscall 

