.data

.align 0
str: .asciiz "Sorted, merged array is : "
spc: .asciiz " "

.align 2
in: .word -5, 0, 2, 11, -2, 0, 1, 13, 15 

out: .space 9




.text

main:
	
	
	la $a0, in
	la $a1, out
	li $a2, 0			#start constant
	li $a3, 4			#mid constant
	addi $sp, $sp, -4
	li $t0, 9				#end goes in stack
	sw $t0, 0($sp)
	jal merge
	
	li $v0, 10
	syscall
	
merge:
	addi $sp, $sp, -4
	sw $ra , 0($sp)
	
	move $t0, $a2				#t0 start
	move $t1, $a3				#t1 mid
	sll $t1, $t1, 2
	lw $t2 , 4($sp)				#t2 end
	sll $t2, $t2, 2
	
	add $t3, $0, $0			#t3 counter
	
	li $s0, 0				#array 1 values
	li $s1, 0				#array 2 values
	
	loop:

		lw $s0, in($t0)
		lw $s1, in($t1)
		
		blt $s0, $s1, L1
		
		sw $s1, out($t3)
		addi $t1, $t1, 4
		addi $t3, $t3, 4
		bge $t1, $t2, array2Done	#t2 contains end index mult by 4
		j loop
		
		L1:
			sw $s0, out($t3)
			addi $t0, $t0, 4
			addi $t3, $t3, 4
			sll $t7, $a3, 2		#multiply index by 4
			bge $t0, $t7, array1Done
			j loop
		
		array1Done:
			loop1:
				lw $s1, in($t1) 
				sw $s1, out($t3)
				addi $t1, $t1, 4
				addi $t3, $t3, 4
				ble $t3, $t2, loop1
			j exit_loop
		array2Done:
			loop2:
				lw $s0, in($t0) 

				sw $s0, out($t3)
				addi $t0, $t0, 4
				addi $t3, $t3, 4
				sll $t7, $a3, 2		#multiply index by 4
				ble $t0, $t7, loop2
			
	exit_loop:
	
		li $v0, 4
		la $a0, str
		syscall
		
		li $t3,0
		
		loop3:
			li $v0, 1
			lw $a0, out($t3)
			syscall
			
			li $v0, 4
			la $a0, spc
			syscall
			
			addi $t3, $t3, 4
			
			blt $t3, $t2, loop3
		
		addi $sp, $sp , 8
		
		jr $ra
	
	
			
				
				
				
			
			
			
		
		

