.data

in_text1: .asciiz "Please give N1:\n"
in_text2: .asciiz "Please give N2:\n"
out1: .asciiz "The max final union of ranges is ["
out2: .asciiz ","
out3: .asciiz "]. \n"

.text

li $s2, 0				#init min max
li $s3, 0


loop:
li $v0, 4
la $a0, in_text1
syscall

li $v0, 5				#Read N1
syscall
move $s0, $v0

bltz $s0, exit

li $v0, 4
la $a0, in_text2
syscall

li $v0, 5				#Read N2
syscall
move $s1, $v0

sub $t0, $s1, $s0			#new region size
sub $t1, $s3, $s2			#old region size

bgt $s0, $s3, size_matters		#case 4/no intersection
bgt $s2, $s1, size_matters		#case 4/no intersection

size_matters:				#set new region according to size
ble $t0, $t1, loop
move $s3, $s1
move $s2, $s0
j loop

bgt $s3, $s1, proceed1			#checking for case 3 or case 1/2
j  orr
proceed1: bgt $s0, $s2, size_matters
orr: bgt $s3, $s1, proceed2
j case_12
proceed2: bgt $s3, $s1, size_matters



case_12:				#checking if case 1 or 2
bgt $s3, $s1, case_1
move $s3, $s1				#case 2
j loop
case_1:					#case 1
move $s2, $s0
j loop

exit:
li $v0, 4
la $a0, out1
syscall

li $v0, 1
move $a0, $s2
syscall

li $v0, 4
la $a0, out2
syscall

li $v0, 1
move $a0, $s3
syscall

li $v0, 4
la $a0, out3
syscall

li $v0, 10
syscall


