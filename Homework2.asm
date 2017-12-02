.data
	
	#Messages to be displayed under given conditions
	
	toobig: .asciiz "Too large"
	errormsg: .asciiz "NaN"
	new_line: .asciiz "\n"
	
	#space allocated for a 1000 characters with the last one being a null character 
	
	inputvalue: .space 1001 
	
.text

main:

	jal input_info
	
loop: 
	
	jal strtend
	
	add $s1, $zero, $v0
	add $s2, $zero, $v1
	
	add $a1, $zero, $v0
	add $a2, $zero, $v1
	
	jal isvalid
	
	add $s3, $zero, $v0
	add $s4, $zero, $v1
	
	add $a1, $zero, $s1
	add $a2, $zero, $s2
	add $a3, $zero, $s3
	add $a4, $zero, $s4
	
	jal function2
	
	add $a1, $zero, $s3
	
	jal funtion3
	
	addi $a1, $s2, 1
	
	j loop
	
   finish:
	li $v0, 10
	syscall
	
	input_info:
		la $a1, inputvalue
		li $v0, 4
		syscall
		
		la $a1, inputvalue
		li $a2, 1000
		li $v0, 8
		syscall
		
		jr $ra
	
strtend:
	
	add $t1, $zero, $a1
		
	begin:		
		lb $t2, 0($t1)
		beq $t2, 0, finish
		beq $t2, 10, finish
		beq $t2, 32, incrstrptr
		beq $t2, 44, incrstrptr
		
		addi $t3, $t1, 1
			
	comma:
		
		lb $t2, 0($t3)
		beq $t2, 0, shftleft
		beq $t2, 10, shftleft
		bne $t2, 44, incrlstptr
			
		addi $t3, $t3, -1
			
	shftleft:
		
		lb $t2, 0($t3)
		beq $t2, 0, declstptr
		beq $t2, 32, declstptr
		beq $t2, 10, declstptr
			
		add $v0, $zero, $t1
		add $v1, $zero, $t3
		
		jr $ra
		
	incrstrptr:
		
		addi $t1, $t1, 1
		j begin
		
	incrlstptr:
		
		addi $t3, $t3, -1
		j comma
			
	declstptr:
		addi $t3, $t3, -1
		j shftleft
		
isvalid:
		
		add $t3, $zero, $zero
		
		valid:
		
			lb $t2, 0($t1)
			bge $t2, 103, Nan 
			bge $t2, 96, incChar
			bge $t2, 71, Nan
			bge $t2, 64, incChar
			bge $t2, 58, Nan
			bge $t2, 47, incChar
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	