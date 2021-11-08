######################################################################
# CSCB58 Winter2021Assembly Final Project
# University of Toronto, Scarborough## Student: Aryan Patel, Student Number, 1006273514
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
# -Milestone 4 (choose the one the applies)
#
# Which approved features have been implementedfor milestone 4?
# (See the assignment handout for the list of additional features)
# 1. Smooth Graphics (no flickering)
# 2. Game Difficulty as time progresses (obstacles move faster)
# 3. Keeping track of Score (time gone by) 
#
# Link to video demonstration for final submission:
# -(insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
#Are you OK with us sharing the video with people outside course staff?
# -yes and please share this project githublink as well!
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
.eqv GREY 0x009e9e9e
.eqv GREEN 0x0073ff00


.data
								# stores address of ship
	shipLoco: .word 0,0,0,0,0 	# top, right, bottom, left, middle 
	object: .word 0,0,0,0,0,0 	# first, second, third
	 				   			# Stores the head of the objects	

.text 

.globl main

# Change the background color to black
blackGround: 

	li $t0, BASE_ADDRESS   		# Base Address
	add $t3, $t0, 4096      	# Your whole Array
	li $t1, BLACK           	# Store Black Color
	loop:
		bge $t0, $t3, DONE  	# Loop tilt end
		sw $t1, 0($t0)      	# Change pixel color to black
		add $t0, $t0, 4
		j loop
	DONE:
		jr $ra

# Start position of spaceship when game starts
startPosition:

	li $t0, BASE_ADDRESS    	# Base Address
	la $t1, shipLoco        	# Address of shipLocation
	li $s0, SPACE_1         	# Store aqua Color
	li $s1, SPACE_2         	# Store pink Color
	
	#left wing 
	add $t0, $t0, 2060      	# 16(128) + 12 
	sw $s0,  0($t0) 
	sw $t0, 12($t1)
	
	#middle of ship
	add $t0, $t0, 4      		# 16(128) + 12 + 4
	sw $s1,  0($t0) 
	sw $t0, 16($t1)
	
	#right of ship
	add $t0, $t0, 4      		# 16(128) + 12 + 4 + 4 
	sw $s0,  0($t0) 
	sw $t0, 4($t1)
	
	#top of ship
	li $t0, BASE_ADDRESS
	add $t0, $t0, 1936      	# 15(128) + 16 
	sw $s0,  0($t0) 
	sw $t0, 0($t1)
	
    #bottom of ship
    li $t0, BASE_ADDRESS
	add $t0, $t0, 2192       	# 17(128) + 16 
	sw $s0,  0($t0) 
	sw $t0, 8($t1)
	
	# Top Border Line
	li $s0, 0
	li $s3, BASE_ADDRESS
	li $s4, 384
	add $s3, $s3, $s4
	
	topLine: 					# Blue Bar below health
		bge $s0, 128, CONT
		add $t0, $s3, $s0
		sw $t5, 0($t0)
		add $s0, $s0, 4
		j topLine
	
	CONT:
	
		jr $ra

# To ensure the ship stays within bounds
BOUNDRY:
	jr $ra

# Move up
UP: 
	la $t0, shipLoco					
	lw $t2, 0($t0) 				# $t2 = current address of ship
								
	sub $t3, $t2, $t3  			

	bge  $t3, 512, AND_UP 		# To check if you are at the boundry (TOP)
	AND_UP:
		ble $t3, 636, BOUNDRY

	sub $t2, $t2, 128 			# $t2 = new address of ship
	sw $s0, 0($t2) 				# Change color in new address
	sw $t2, 0($t0) 				# Store new address
	
	# Repeat for the rest of the space ship part
	# move bottom of ship up 1
	lw $t2, 8($t0)
	sw $s2, 0($t2) 				# change old location's color 
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

# Move Down
DOWN: 
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
	lw $t2, 0($t0) 				# $t2 = current address of ship
	sw $s2, 0($t2)				# chagne old location's color
	add $t2, $t2, 128 			# $t2 = new address of ship
	sw $s0, 0($t2)				# Change color in new address
	sw $t2, 0($t0) 				# Store new address

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

# Move Left
LEFT: 
	la $t0, shipLoco
	
	# move left side of ship left 1
	lw $t2, 12($t0)	
	li $s3, 128
	div $t2, $s3
	mfhi $s3
	
	# check if at BOUNDRY
	beq $s3, 0, BOUNDRY
	
	sw $s1, 0($t2)
	sub $t2, $t2, 4
	sw $s0, 0($t2)
	sw $t2, 12($t0)
								# move top of ship left one
	lw $t2, 0($t0) 				# $t2 = current address of ship
	sw $s2, 0($t2) 				# chagne old location's color
	sub $t2, $t2, 4 			# $t2 = new address of ship
	sw $s0, 0($t2) 				# Change color in new address
	sw $t2, 0($t0) 				# Store new address
	
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
	
# Move right
RIGHT: 
	la $t0, shipLoco
	
	# move right side of ship up 1
	lw $t2, 4($t0)
	
	move $s3, $t2
	sub $s3, $s3, 124
	li $s4, 128
	div $s3, $s4
	mfhi $s3
	
	# Check if at BOUNDRY
	beq $s3, 0, BOUNDRY
	
	sw $s1, 0($t2)
	add $t2, $t2, 4
	sw $s0, 0($t2)
	sw $t2, 4($t0)

	
	# move top of ship right 1
	lw $t2, 0($t0) 				# $t2 = current address of ship
	sw $s2, 0($t2) 				# chagne old location's color
	add $t2, $t2, 4 			# $t2 = new address of ship
	sw $s0, 0($t2) 				# Change color in new address
	sw $t2, 0($t0) 				# Store new address
	
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

# User Input
keyPressed:
	lw $t0, 4($t8)
	li $t3, BASE_ADDRESS
	li $s0, SPACE_1         	# Store aqua Color
	li $s1, SPACE_2         	# Store pink Color
	li $s2, BLACK         		# Store pink Color
	
	move $t1, $ra
	beq $t0, 119, UP 			#input w go up
	beq $t0, 115, DOWN 			#input d go up
	beq $t0, 97, LEFT 			#input a go left
	beq $t0, 100, RIGHT 		#input d go left
	move $ra, $t1
			
	beq $t0, 112, main #input P pressed to PLAY
	
	jr $ra

Start:
	li $t0, BASE_ADDRESS    	# Base Address
	li $t1, BASE_ADDRESS    	# To Change
	
	# Colors
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
	
	# print R of RUN
	sw $t6, 1852($t1)
	sw $t7, 1980($t1)
	sw $t5, 2108($t1)
	sw $t5, 2236($t1)
	sw $t5, 2364($t1)	
	sw $t6, 1856($t1)
	sw $t6, 1860($t1)
	sw $t6, 1988($t1)
	sw $t6, 2116($t1)
	sw $t7, 2240($t1)
	sw $t6, 2372($t1)
	
	# Print U of RUN 
	sw $t6, 1868($t1)
	sw $t7, 1996($t1)
	sw $t5, 2124($t1)
	sw $t5, 2252($t1)
	sw $t5, 2384($t1)
	sw $t7, 2260($t1)
	sw $t6, 2132($t1)
	sw $t7, 2004($t1)
	sw $t7, 1876($t1)
	
	# print N of RUN 
	sw $t6, 1884($t1)
	sw $t6, 2012($t1)
	sw $t6, 2140($t1)
	sw $t7, 2268($t1)
	sw $t7, 2396($t1)
	sw $t6, 2016($t1)
	sw $t7, 2148($t1)
	sw $t7, 2280($t1)
	sw $t5, 2412($t1)
	sw $t5, 2284($t1)
	sw $t5, 2156($t1)
	sw $t7, 2028($t1)
	sw $t7, 1900($t1)
	
	# print quotation
	sw $t8, 2864($t1)
	sw $t8, 2740($t1)
	sw $t8, 2764($t1)
	sw $t8, 2896($t1)
	
	
	# print P
	sw $t9, 3004($t1)
	sw $t9, 3008($t1)
	sw $t9, 3012($t1)
	sw $t9, 3140($t1)
	sw $t9, 3132($t1)
	sw $t9, 3260($t1)
	sw $t9, 3264($t1)
	sw $t9, 3268($t1)
	sw $t9, 3388($t1)
	sw $t9, 3516($t1)

	jr $ra
	
# Initialize each of the objects 
# Flying towards the ship
initializeObject:

	# $a0 passed in to specify the object you initializing 0, 4 or 8
	# Uses $a0 to index into object Array
	
	li $t7, BASE_ADDRESS
	la $t0, object 				# get BASE address of Object
	li $t1, 760     			# Constant
	li $t2, 128     			# Constant
	li $s0, DARK_RED        	# Store aqua Color
	
	add $t0, $t0, $a0
	
	# get a random int, Store it in $a0
	li $v0, 42
	li $a0, 5
	li $a1, 26
	syscall	

	# Calculate Address + 248 + $a0(128) <- Position of FIRST Space Ship
	add $t3, $t7, $t1 			# Address + 248
	mul $t4, $a0, $t2 			# $a0(128)
	add $t3, $t3, $t4 			# Address + 251 + $a0(128)
	
	sw $t3, 0($t0) 				# Store the address of the first ship in objects
	sw $s0, 0($t3) 				# Change color in the board
	sw $s0, -124($t3) 			# Change color in the board
	sw $s0, 132($t3) 			# Change color in the board

	jr $ra

# Reset the objects once they reach the end of their path
resetObject:

	# $a0 = Object that you need to reset 0 4 or 8 in memory
	# Uses $a0 to index into object Array
	
	#t6 global var score
	add $t6, $t6, 1
	add $s6, $s6, 1
	
	li $t7, BASE_ADDRESS
	la $t0, object 				# get BASE address of Object
	li $s0, DARK_RED       
	li $s1, BLACK
	
	add $t0, $t0, $a0 			# the object you want to reset
	lw $t0, 0($t0)
	
	sw $s1, 0($t0) 				# Change color in the board
	sw $s1, -124($t0) 			# Change color in the board
	sw $s1, 132($t0) 			# Change color in the board
	
	addi $sp, $sp, -4     		# Move stack pointer one word 
	sw $ra, 0($sp)        		# Add $ra to the stack 
	
	jal initializeObject
	
	lw $ra, 0($sp)        		# Load the return value
	addi $sp, $sp, 4      		# Pop return value from the stack
	
	# Now that object has to have a random starting position
	jr $ra

# Move object at each frame
moveObjectSpecific:
	
	# $a0 is the ship to be moved
	# index into object array using $a0 
	li $t7, BASE_ADDRESS
	la $t0, object 				# get BASE address of Object
	li $s0, DARK_RED       
	li $s1, BLACK
	li $s3, 128
	
	# The Specific Ship You Want to move
	add $t0, $t0, $a0
	                            # Check if you are at the border
    lw $t3, 0($t0)              # Get the location of the ship (in general)
    sub $t3, $t3, $t7           # subtract the base location
    div $t3, $s3
    mfhi $s3
    
	addi $sp, $sp, -4     		# Move stack pointer one word 
	sw $ra, 0($sp)       		# Add $ra to the stack 
    beq $s3, 0, resetObject
	lw $ra, 0($sp)        		# Load the return value
	addi $sp, $sp, 4      		# Pop return value from the stack

								# else move the ships 
	lw $t3, 0($t0) 				# Get the location of object 1
								# make previos position black
	sw $s1, 0($t3) 				# Change color in the board
	sw $s1, -124($t3) 			# Change color in the board
	sw $s1, 132($t3) 			# Change color in the board
								# Change color of next position
	sub $t3, $t3, 4
	sw $t3, 0($t0)
	sw $s0, 0($t3) 				# Change color in the board
	sw $s0, -124($t3) 			# Change color in the board
	sw $s0, 132($t3) 			# Change color in the board

	jr $ra

# Function that moves each object
# Changes $a0 3 times for each object
moveObject:
	
	addi $sp, $sp, -4     	# Move stack pointer one word 
	sw $ra, 0($sp)        	# Add $ra to the stack 
	
	# Move each object
	li $a0, 0
	jal moveObjectSpecific
	li $a0, 4
	jal moveObjectSpecific
	li $a0, 8
	jal moveObjectSpecific
	
	lw $ra, 0($sp)        	# Load the return value
	addi $sp, $sp, 4      	# Pop return value from the stack
	
	jr $ra
	
# Check if collision has occurred
collisionOccured:
	addi $sp, $sp, -4     	# Move stack pointer one word 
	sw $ra, 0($sp)        	# Add $ra to the stack 
	
	# Subtract 1 life
	add $t9, $t9, 1
	
	#$a0 is the offset in object of the object that was hit by ship
	li $s4, BLACK
	add $s3, $s1, $a0 		# memory address of object hit by ship
	lw $s3, 0($s3)    		# location of head of object
	
	sw $s4, 0($s3)
	sw $s4, -124($s3)
	sw $s4, 132($s3)
	
	# Collision Animation
	li $t7, ORANGE 
	li $t5, YELLOW
	
	move $t0, $a0
	
	lw $s7, 0($t1)
	sw $t7, 0($s7)
	
	li $v0, 32
	li $a0, 150
	syscall
	
	lw $s7, 4($t1)
	sw $t7, 0($s7)
	
	li $v0, 32
	li $a0, 150
	syscall
	
	lw $s7, 8($t1)
	sw $t7, 0($s7)
	
	li $v0, 32
	li $a0, 150
	syscall
	
	lw $s7, 12($t1)
	sw $t7, 0($s7)
	
	
	li $v0, 32
	li $a0, 150 
	syscall
	
	
	lw $s7, 16($t1)
	sw $t5, 0($s7)
	
	li $v0, 32
	li $a0, 1000 # 25 hertz Refresh rate
	syscall
	
	move $a0, $t0
	
	# Reset object that hit the ship
	jal resetObject
	
	lw $ra, 0($sp)        	# Load the return value
	addi $sp, $sp, 4      	# Pop return value from the stack
	
	# Reset the colors on the ship to original
	# After it was hit
	li $t7, SPACE_1 
	li $t5, SPACE_2
	la $t1, shipLoco
	
	lw $s7, 0($t1)
	sw $t7, 0($s7)
	lw $s7, 4($t1)
	sw $t7, 0($s7)
	lw $s7, 8($t1)
	sw $t7, 0($s7)
	lw $s7, 12($t1)
	sw $t7, 0($s7)
	lw $s7, 16($t1)
	sw $t5, 0($s7)

	jr $ra

# Check for Collision
collision:
	addi $sp, $sp, -4     	# Move stack pointer one word 
	sw $ra, 0($sp)        	# Add $ra to the stack 
	
	li $t0, 0
	la $t1, shipLoco
	la $s1, object
	
	# Loops through each index of Ship
	loopShipLoco:
		bge $t0, 20, leave
		add $t3, $t0, $t1
		lw $t3, 0($t3)
		li $t4, 0
		
		# Loops through each index of 3 objects
		loopObject:
			bgt $t4, 8, continue
			add $s2, $s1, $t4
			lw $s2, 0($s2)
			move $a0, $t4 						# keep track of which ship was hit, pass by parameter
			beq $s2, $t3, collisionOccured		# Check if the head of the object matchs 
			add $s2, $s2, -124 					# check if right of object was hit
			beq $s2, $t3, collisionOccured
			add $s2, $s2, 256 					# check if left of object was hit
			beq $s2, $t3, collisionOccured
			add $t4, $t4, 4
			j loopObject
		
		continue: 
			add $t0, $t0, 4
			
		j loopShipLoco
	
	leave:
		lw $ra, 0($sp)      # Load the return value
		addi $sp, $sp, 4    # Pop return value from the stack
		
		jr $ra

# Show Ships Health
setHealth:
	li $t0, BASE_ADDRESS
	li $s0, GREEN
	
	sw $s0, 232($t0)
	sw $s0, 236($t0)
	sw $s0, 240($t0)
	sw $s0, 244($t0)
	sw $s0, 248($t0)
	
	jr $ra
	
# Update Health if hit
updateHealth:
	li $s0, GREY
	li $s1, YELLOW
	li $t0, BASE_ADDRESS
	
	# Check lifes
	beq $t9, 1, ONE
	beq $t9, 2, TWO
	beq $t9, 3, THREE
	beq $t9, 4, FOUR
	beq $t9, 5, FIVE
	
	# No Change
	j noChange
	
	# Depending on lifes, show decrement to user 
	ONE:
		sw $s0, 232($t0)
		j noChange
		
	TWO:
		sw $s0, 236($t0)
		j noChange
	
	THREE:
		sw $s0, 240($t0)
		j noChange
	
	FOUR:
		sw $s0, 244($t0)
		j noChange
		
	FIVE:
		
		# Animation once the health has delimished
		sw $s0, 248($t0)
		
		li $v0, 32
		li $a0, 500 # 25 hertz Refresh rate
		syscall
		
		sw $s1, 232($t0)
		sw $s1, 236($t0)
		sw $s1, 240($t0)
		sw $s1, 244($t0)
		sw $s1, 248($t0)
		
		li $v0, 32
		li $a0, 500 # 25 hertz Refresh rate
		syscall
		
		sw $s0, 232($t0)
		sw $s0, 236($t0)
		sw $s0, 240($t0)
		sw $s0, 244($t0)
		sw $s0, 248($t0)
		
		li $v0, 32
		li $a0, 500 # 25 hertz Refresh rate
		syscall
		
		sw $s1, 232($t0)
		sw $s1, 236($t0)
		sw $s1, 240($t0)
		sw $s1, 244($t0)
		sw $s1, 248($t0)
		
		li $v0, 32
		li $a0, 500 # 25 hertz Refresh rate
		syscall
		
		sw $s0, 232($t0)
		sw $s0, 236($t0)
		sw $s0, 240($t0)
		sw $s0, 244($t0)
		sw $s0, 248($t0)

	noChange:
		jr $ra
	
# Increasing Difficultity as Game Progresses
speedUp:
	move $t0, $ra
	
	# Ships move faster as you get 10 points 
	# ie. 10 -> faster , 20 -> even faster ...
	bne $s6, 10, noSpeed
	ble $s5, 23, noSpeed
	add $s5, $s5, -6
	move $s6, $zero
	
	noSpeed:	
		move $ra, $t0
		jr $ra

# Main Game Loop
main:
	
	# Black the Screen
	jal blackGround
	
	# Show Starting Screen
	jal Start 
	
	li $t8, 0xffff0000 		# input
	li $t1, 2 				# resetting input value
	sw $t1, 4($t8) 			# resetting input value
	
	# Check for user input "p" for play
	startPage:
		lw $t0, 4($t8)
		bne $t0, 112, startPage	
	
	# Black the screen
	# Ship appears 
	# Health Apppears
	jal blackGround
	jal startPosition
	jal setHealth
	
	# Initialize the scoress 
	# You have 3 lifes
	li $t9, 0                 
	li $t6, 1 # score
	li $t7, BASE_ADDRESS
	
	# Initialize Object
	li $a0, 0
	jal initializeObject 
	li $a0, 4
	jal initializeObject 
	li $a0, 8
	jal initializeObject 
	
	# Global Var for increasing difficluty
	# $s5 = Refresh Rate
	li $s5, 60
	li $s6, 0
	
	# Game Loop
	gameLoop:
		bge  $t9,5 END        		# If you have 0 lifes you are finished.
		jal speedUp 				# if mod 10 of score = 0, then increase speed
		lw $t0, 0($t8)
		beq $t0, 1, keyPressed      # User Input for ship / reset
		
		# Check for collision, update health if collision, and move object
		jal collision
		jal updateHealth
		jal moveObject
				
		# Refresh Rate
		li $v0, 32
		add $a0, $s5, $zero
		#li $a0, 32 # 25 hertz Refresh rate <- If you want one refresh rate instead of increasing difficulty
		syscall
		
		j gameLoop

# Show End Screen
END:
	jal blackGround
	jal END_PAGE 
	jal PRINT_SCORE
	li $t8, 0xffff0000
	
	# Check if user wants to restart
	restart:
		li $t0, 0 
		beq $t8, 1, key
		key:
			lw $t7, 4($t8) 			# check which key was pressed
			beq $t7, 112, main
			j restart
	
	li $v0, 10
	syscall 

# Print 0 - 9 to display score
PRINT_ZERO:
	sw $s2, 0($a0)
	sw $s2, 4($a0)
	sw $s2, 8($a0)
	sw $s2, 136($a0)
	sw $s2, 264($a0)
	sw $s2, 392($a0)
	sw $s2, 520($a0)
	sw $s2, 516($a0)
	sw $s2, 512($a0)
	sw $s2, 384($a0)
	sw $s2, 256($a0)
	sw $s2, 128($a0)
	jr $ra
	
PRINT_ONE: 

	sw $s2, 4($a0)
	sw $s2, 132($a0)
	sw $s2, 260($a0)
	sw $s2, 388($a0)
	sw $s2, 516($a0)
	jr $ra
	
PRINT_TWO:
	
	sw $s2, 0($a0)
	sw $s2, 4($a0)
	sw $s2, 136($a0)
	sw $s2, 260($a0)
	sw $s2, 384($a0)
	sw $s2, 512($a0)
	sw $s2, 516($a0)
	sw $s2, 520($a0)
	jr $ra
	
PRINT_THREE:
	sw $s2, ($a0)
	sw $s2, 4($a0)
	sw $s2, 136($a0)
	sw $s2, 260($a0)
	sw $s2, 256($a0)
	sw $s2, 392($a0)
	sw $s2, 516($a0)
	sw $s2, 512($a0)
	jr $ra
	
PRINT_FOUR:
	sw $s2, ($a0)
	sw $s2, 128($a0)
	sw $s2, 256($a0)
	sw $s2, 260($a0)
	sw $s2, 264($a0)
	sw $s2, 136($a0)
	sw $s2, 392($a0)
	sw $s2, 520($a0)
	jr $ra
	
PRINT_FIVE:
	sw $s2, 8($a0)
	sw $s2, 4($a0)
	sw $s2, 0($a0)
	sw $s2, 128($a0)
	sw $s2, 260($a0)
	sw $s2, 264($a0)
	sw $s2, 392($a0)
	sw $s2, 520($a0)
	sw $s2, 516($a0)
	sw $s2, 512($a0)
	sw $s2, 256($a0)
	
	jr $ra
	
PRINT_SIX:
	sw $s2, 8($a0)
	sw $s2, 4($a0)
	sw $s2, 0($a0)
	sw $s2, 128($a0)
	sw $s2, 260($a0)
	sw $s2, 264($a0)
	sw $s2, 392($a0)
	sw $s2, 520($a0)
	sw $s2, 516($a0)
	sw $s2, 512($a0)
	sw $s2, 256($a0)
	sw $s2, 384($a0)
	
	jr $ra

PRINT_SEVEN:
	sw $s2, ($a0)
	sw $s2, 4($a0)
	sw $s2, 8($a0)
	sw $s2, 136($a0)
	sw $s2, 260($a0)
	sw $s2, 384($a0)
	sw $s2, 512($a0)

	jr $ra
	
PRINT_EIGHT:
	sw $s2, 8($a0)
	sw $s2, 4($a0)
	sw $s2, 0($a0)
	sw $s2, 136($a0)
	sw $s2, 128($a0)
	sw $s2, 260($a0)
	sw $s2, 264($a0)
	sw $s2, 392($a0)
	sw $s2, 520($a0)
	sw $s2, 516($a0)
	sw $s2, 512($a0)
	sw $s2, 256($a0)
	sw $s2, 384($a0)
	
	jr $ra

PRINT_NINE:
	sw $s2, 8($a0)
	sw $s2, 4($a0)
	sw $s2, 0($a0)
	sw $s2, 136($a0)
	sw $s2, 128($a0)
	sw $s2, 260($a0)
	sw $s2, 264($a0)
	sw $s2, 392($a0)
	sw $s2, 520($a0)
	sw $s2, 516($a0)
	sw $s2, 512($a0)
	sw $s2, 256($a0)
	
	jr $ra

PRINT_DIGIT:

	move $t7, $ra
	
	# Abstract, pass in parameter to display digit
	# $a1 is the digit you want to print
	# $a0 is the location you want to print within the board
	
	beq $a1, 0, PRINT_ZERO
	beq $a1, 1, PRINT_ONE
	beq $a1, 2, PRINT_TWO
	beq $a1, 3, PRINT_THREE
	beq $a1, 4, PRINT_FOUR
	beq $a1, 5, PRINT_FIVE
	beq $a1, 6, PRINT_SIX
	beq $a1, 7, PRINT_SEVEN
	beq $a1, 8, PRINT_EIGHT
	beq $a1, 9, PRINT_NINE
	
	move $ra, $t7
	jr $ra
	
# Significant FIRST the store $s1 to 1 XXX <- FIRST X is your significant first digit
# the n'th significant digit = (x % 1000) / 100
# $a0 is your score
SIGNIFICANT_FIRST :
	move $t1, $ra
	
	# If score less than 100, show 0XX 
	ble $a0, 99, less_then

	li $t2, 1000 
	div $a0, $t2
	mfhi $a1
	
	li $t2, 100
	div $a1, $t2
	mflo $a1
	
	# Location you want to print the digit (first digit)
	li $a0, 1448
	add $a0, $a0, $t0
	
	# Print Digit Depending on $a1 (passing by argument)
	jal PRINT_DIGIT
	move $ra, $t1
	jr $ra
	
	# Display 0 for first digit if score < 100
	less_then:
		li $a1, 0
		li $a0, 1448
		add $a0, $a0, $t0
		jal PRINT_DIGIT
		move $ra, $t1
		jr $ra
		
# Significant SECOND the store $s1 to 1 XXX <- SECOND LAST X is your second digit
# the n'th significant digit = (x % 100) / 10 
# $a0 is your score	
SIGNIFICANT_SECOND:
	move $t8, $ra
	
	li $t2, 100 
	div $a0, $t2
	mfhi $a1
	
	li $t2, 10
	div $a1, $t2
	mflo $a1
	
	# Location you want to print the digit
	li $a0, 1464
	add $a0, $a0, $t0
	
	# Print Digit Depending on $a1 (passing by argument)
	jal PRINT_DIGIT
	
	move $ra, $t8
	jr $ra
	
# Significant third the store $s1 to 1 XXX <- last X is your thrid digit
# the n'th significant digit = (x % 10) 
SIGNIFICANT_THIRD:
	move $t8, $ra
	
	li $t2, 10 
	div $a0, $t2
	mfhi $a1
	
	# Location you want to print the digit
	li $a0, 1480
	add $a0, $a0, $t0
	
	# Print Digit Depending on $a1 (passing by argument)
	jal PRINT_DIGIT
	
	move $ra, $t8
	jr $ra
	
# Print the score
PRINT_SCORE:
	# $t6 has the score in the register
	# Calculate the significant digits 
	# $a0 is the address of where to draw the digit given significant digit
	# Store Address
	move $t9, $ra
	li $t0, BASE_ADDRESS
	li $s2, LIGHT_RED
	
	#Calculate the second significant Digit & print
	add $a0, $zero, $t6
	jal SIGNIFICANT_SECOND
	
	#Calculate Least Significant Digit & print
	add $a0, $zero, $t6
	jal SIGNIFICANT_THIRD
	
	#Calculate the first significant digit & print
	add $a0, $zero, $t6
	jal SIGNIFICANT_FIRST 
	
	move $ra, $t9
	jr $ra
	
# Graphics for end page
# Animation with the graphics
END_PAGE:
	li $t0, BASE_ADDRESS
	li $s0, DARK_RED
	li $s1, RED
	li $s2, LIGHT_RED
	li $s3, ORANGE
	li $s4, YELLOW
	
	#RED PART
	sw $s0, 792($t0)
	sw $s0, 796($t0)
	sw $s0, 672($t0)
	sw $s0, 812($t0)
	sw $s0, 816($t0)
	sw $s0, 828($t0)
	sw $s0, 832($t0)
	sw $s0, 844($t0)
	sw $s0, 852($t0)
	sw $s0, 860($t0)
	sw $s0, 864($t0)
	sw $s0, 868($t0)
	sw $s0, 680($t0)
	sw $s0, 696($t0)
	sw $s0, 708($t0)
	sw $s0, 716($t0)
	sw $s0, 732($t0)
	
	li $v0, 32
	li $a0, 300 # 25 hertz Refresh rate
	syscall
	
	# red Area
	sw $s1, 724($t0) 
	sw $s1, 540($t0) 
	sw $s1, 552($t0)
	sw $s1, 568($t0)
	sw $s1, 580($t0)
	sw $s1, 588($t0)
	sw $s1, 592($t0)
	sw $s1, 604($t0)
	sw $s1, 608($t0)
	sw $s1, 408($t0)
	sw $s1, 424($t0)
	sw $s1, 440($t0)
	sw $s1, 460($t0)
	
	li $v0, 32
	li $a0, 300 # 25 hertz Refresh rate
	syscall
	
	#light area
	sw $s2, 452($t0)
	sw $s2, 468($t0)
	sw $s2, 476($t0)
	sw $s2, 284($t0)
	sw $s2, 288($t0)
	sw $s2, 300($t0)
	sw $s2, 304($t0)
	sw $s2, 316($t0)
	sw $s2, 320($t0)
	sw $s2, 332($t0)
	sw $s2, 336($t0)
	sw $s2, 340($t0)
	sw $s2, 348($t0)
	sw $s2, 352($t0)
	sw $s2, 356($t0)
	
	li $v0, 32
	li $a0, 300 # 25 hertz Refresh rate
	syscall
	
	#Quotation
	sw $s3, 2860($t0)
	sw $s3, 2736($t0)
	sw $s3, 2760($t0)
	sw $s3, 2892($t0)
	
	# print P
	sw $s4, 3000($t0)
	sw $s4, 3004($t0)
	sw $s4, 3008($t0)
	sw $s4, 3136($t0)
	sw $s4, 3128($t0)
	sw $s4, 3256($t0)
	sw $s4, 3260($t0)
	sw $s4, 3264($t0)
	sw $s4, 3384($t0)
	sw $s4, 3512($t0)

	jr $ra
	
	
