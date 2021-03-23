.data

in1: .asciiz "Please give a string: "
in2: .asciiz "\nPlease give a substring: "
out: .asciiz "\nThe max substring has length: "

.text

main:
	li $a1, 100

	li $v0, 4					#Print in1
	la $a0, in1
	syscall
	
	li $v0, 8					#Read string
	syscall
	move $a1, $a0					#a1 contains string
	
	li $v0, 4					#Print in2
	la $a0, in2
	syscall	
	
	li $v0, 8					#Read substring
	syscall
	move $a2, $a0					#a2 contains substring
				
	jal substring
	
	li $v0, 4					#prints
	la $a0, out
	syscall
	
	li $v0, 1
	move $a0, $v1
	syscall
	
	li $v0, 10					#exit program
	syscall
	
substring:
	move $t0, $a1					#string index
	move $t1, $a2					#substring index 
	li $t2, 0					#counter
	li $t3, 0					#max counter
	
	loop:
		lb $t4, 0($t0)				#load char of string
		lb $t5, 0($t1)				#load char of substring
		
		beq $t4, 10, exit_loop			#if string index-value is \n exit loop 
		
		bne $t5, 10, continue			#if substring index-value is \n 
		move $t1, $a2				#set substring index to start
		
		continue:	
			beq $t4, $t5, move_both		#if the elements are equal move both indexes by 1
			move $t1, $a2			#special occasion
			lb $s0,0($t0)			
			lb $s1, 0($t1)			
			beq $s0, $s1, no_incr
			addi $t0, $t0, 1 
		
		no_incr:
			bgt $t2,$t3, change_max
		
		reset: li $t2,0
			j end_daloop
		
		move_both:
			addi $t0, $t0, 1
			addi $t1, $t1, 1
			addi $t2, $t2, 1
			j end_daloop
			
		change_max:
			move $t3, $t2
			j reset

			
		end_daloop:
			beq $t4, 0, exit_loop		#conditions to break
			beq $t5, 0, exit_loop
			
			j loop
			
	exit_loop:
		bge $t2,$t3, jump1			#last check for max_counter
		j jump2
		jump1:
			move $t3, $t2
		jump2:
		move $v1, $t3
		jr $ra	
	