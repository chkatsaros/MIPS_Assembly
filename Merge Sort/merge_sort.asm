############### merge (in, out, start, mid, end)  ################
########    merge the two sorted arrays in[start:mid-1] and in[mid:end-1] 
############   and write the sorted output array to out[start:end-1] 
#################################################################

### Question: what should the value of mid parameter be to express empty arrays?  #######

.data
# statically defined input strings
      .asciiz "\n"

.align 2
  A:
      .word  -56, -50, 0,12, 23, 100, 110, 10001, -100, 13, 111, 2000
  B:	
      .space 400
      
  start:
      .word 0 	 
	
  end:
      .word 12
      
#################################################

# Implement the merge function in MIPS assembly 
.text
.globl main            		# label "main" must be global

.macro print_array_int(%x, %y)   #macro to print an array of %y integers. Array starts at %x
print_loop:
  	beqz %y, end_of_macro
  	li $v0, 1
  	lw $a0, 0(%x)
  	syscall
  	li $v0, 11
  	li $a0, ','
  	syscall
  	li $a0, ' '
  	syscall
  	addi %y, %y, -1
  	addi %x, %x, 4
  	j print_loop
end_of_macro:
.end_macro

###################  main #####################
main:  
  	la $a0, B       # address of in array
  	la $a1, A      # address of out array
  	la $a2, start    # start of in[start:mid-1] array
  	lw $a2, 0($a2)
  	la $a3, end      # the fifth parameter is the end of the in[] array. Main() puts it in the stack before calling merge
  	lw $a3, 0($a3)
  	
  	addi $t0, $a3, -1
  	addi $t4, $0, 0 	#loop counter 
  	la $t1, B	#index of B
 	la $t2, A
 	copy_loop:

 		lw $t3, 0($t2)	#t3 contains the current integer
 		
 		sw $t3, 0($t1)
 		addi $t2, $t2, 4
 		addi $t1, $t1, 4
 		addi $t4, $t4, 1
 		ble $t4, $t0, copy_loop
 	
  	jal merge_sort        # call the function 

  	addi $sp, $sp, 20    # upon return, empty the stack 
   
  	la $s0, A         # and print out the array
  	li $s1, 12
  	print_array_int($s0, $s1)
    
	# Exit progem
  	li $v0, 10
  	syscall
  
  
merge_sort:
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	sw $a3, 0($sp)
	
	sub $t0, $a3, $a2 	
	bgt $t0, 1, L
	
	addi $sp, $sp, 20
	jr $ra
	
	L:	

		add $t1, $a2, $a3
		srl $t1, $t1, 1
		move $a3, $t1
		
		move $t3, $a1
		move $a1, $a0	#switch $a0, $a1
		move $a0, $t3
		
		jal merge_sort
		
		lw $ra, 16($sp)
		lw $a0, 12($sp)
		lw $a1, 8($sp)
		lw $a2, 4($sp)
		lw $a3, 0($sp)
		
		add $t1, $a2, $a3
		srl $t1, $t1, 1
		move $a2, $t1
		
		move $t3, $a1
		move $a1, $a0	#switch $a0, $a1 
		move $a0, $t3
		
		
		
		jal merge_sort
		
		lw $ra, 16($sp)
		lw $a0, 12($sp)
		lw $a1, 8($sp)
		lw $a2, 4($sp)
		lw $a3, 0($sp)
		
		add $t1, $a2, $a3
		srl $t1, $t1, 1
		
		addi $sp, $sp, -4
		sw $a3, 0($sp)
		move $a3, $t1
		jal merge
		addi $sp, $sp, 4
		
		LL:
			lw $a3, 0($sp)
			lw $a2, 4($sp)
			lw $a1, 8($sp)
			lw $a0, 12($sp)
			lw $ra, 16($sp)
			addi $sp, $sp, 20
			jr $ra

##############################  merge function  ################################################
# merge (in, out, start, mid, end)
merge:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	lw $t0, 12($sp)    # end

	sll  $s0, $a2, 2
    	add  $s0, $a0, $s0  # $s0 is the running pointer of array in[start:mid-1]
    	sll  $s1, $a3, 2
    	add  $s1, $a0, $s1  # $s1 is the running pointer of array in[mid:end-1]	
    	move $t5, $s1       # $t5 points at mid 
    	sll $t6, $t0, 2
    	add $t6, $a0, $t6   # $t6 points at end

   	sll  $s2, $a2, 2
    	add $s2, $a1, $s2
    	move $v0, $s2
    	li $t8, 0    
    	sub $t7, $t0, $a2   # $t7 is the sum of the sizes of the two array 

loop:
	bge $t8, $t7, Exit
	li $t3, 0x7FFFFFFF
	li $t4, 0x7FFFFFFF
	bge $s0, $t5, Lb1
	lw $t3, 0($s0)
Lb1:	bge $s1, $t6, Lb2 
	lw $t4, 0($s1)
Lb2:	ble $t3, $t4, L1
	sw $t4, 0($s2)
	addi $s1, $s1, 4
        j L2		
L1:	
        sw $t3, 0($s2)
        addi $s0, $s0, 4
L2:
	addi $s2, $s2, 4
	addi $t8, $t8, 1
	j loop	
	
Exit:	lw $s2, 0($sp)		
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $s2
