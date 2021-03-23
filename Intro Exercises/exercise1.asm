.data
is: .asciiz " is a power of 2. \n"
isnt: .asciiz " isn't a power of 2. \n"
.text

add $t1,$0,$0		#t1 1s' counter
li $v0, 5		# Read num
syscall 

move $t0, $v0  		#t0 Num  
move $s1, $t0   	#s1 holds the original num
add $t2,$0,$0 		#t2 = result of bitwise and

loop:
bge $t1, 2, exit_loop	#no need to search further if ones >= 2
and $t2 , $t0 ,1	#check if LSB=1
bne $t2, 1, not_one	
add $t1,$t1 ,1

not_one:		#shift right
srl $t0,$t0,1 
bne $t0 ,$0,loop

exit_loop:
li $v0, 1                                   
move $a0, $s1   
syscall 

bne $t1,1,isntPow

li  $v0, 4                     
la  $a0, is
syscall 
j exit
isntPow:
li  $v0, 4                     
la  $a0, isnt
syscall 

exit:
li $v0 , 10 		#exit
syscall

 
