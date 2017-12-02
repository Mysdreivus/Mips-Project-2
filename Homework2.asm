
.data
	
	#Messages to be displayed under given conditions
	
	toobigmsg: .asciiz "Too large"
	errormsg: .asciiz "NaN"
	new_line: .asciiz "\n" 
	inputvalue: .space 1001 
	
.text
main:


	jal input_info
	
loop: 
	
	jal strtend
	
	add $s1, $zero, $v0
	add $s2, $zero, $v1
	
	add $a0, $zero, $v0
	add $a1, $zero, $v1
	
	jal isvalid
	
	add $s3, $zero, $v0
	add $s4, $zero, $v1
	
	add $a0, $zero, $s1
	add $a1, $zero, $s2
	add $a2, $zero, $s4
	add $a3, $zero, $s3
	
	jal subprogram_2
	
	add $a0, $zero, $s3
	
	jal subprogram_3
	
	addi $a0, $s2, 1
	
	j loop
	
   end:
	li $v0, 10
	syscall
	
	input_info:
		la $a0, inputvalue
		li $v0, 4
		syscall
		
		la $a0, inputvalue
		li $a1, 1000
		li $v0, 8
		syscall
		
		jr $ra
	
strtend:
	
	add $t1, $zero, $a0
		
	begin:		
		lb $t2, 0($t1)
		beq $t2, 0,  end
		beq $t2, 10, end
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
		
		lb  $t2, 0($t1)
		bge $t2, 103, Nan 
		bge $t2, 96, incChar
		bge $t2, 71, Nan
		bge $t2, 64, incChar
		bge $t2, 58, Nan
		bge $t2, 47, incChar
			
		j Nan
		
	incChar:
		addi $t1, $t1, 1
		addi $t3, $t3, 1
		bgt $t1, $a1, val
		j valid
			
	Nan:
		addi $v0, $zero, 1
		addi $v1, $zero, 0
		jr $ra
			
	tooLarge:
		addi $v0, $zero, 2
		addi $v1, $zero, 0
		jr $ra
		
	val:
		bgt $t3, 8, tooLarge
		addi $v0, $zero, 3
		add  $v1, $zero, $t3
		jr $ra
		
return:
		
	jr $ra
		
subprogram_1:
    addi $v0, $zero, 1                 
    addi $t4, $zero, 16                 

  ascii_to_hex:
    bge $a2, 96, lower                  
    bge $a2, 64, upper                
    bge $a2, 47, number                 

  lower:
    addi $t1, $a2, -87                  
    j calc_exp

  upper:
    addi $t1, $a2, -55                 
    j calc_exp

  number:
    addi $t1, $a2, -48                  
    j calc_exp

  calc_exp:
    sub $t2, $a0, $a1                
    addi $t2, $t2, -1                   

  raise_to_exp:
    beq $t2, $zero, multiply            

    mult $v0, $t4                      
    mflo $v0                           

    addi $t2, $t2, -1                   
    j raise_to_exp

  multiply:
    mult $v0, $t1                    
    mflo $v0                            

    jr $ra                    

subprogram_2:

    bne $a3, 3, return                  
    add $t1, $zero, $a0                 
    add $t2, $zero, $a1                 
    add $t3, $zero, $a2                 
    add $s6, $zero, $zero              
    add $t5, $zero, $t0                 
    add $t9, $zero, $zero               

    add $s5, $zero, $ra                
     
  hexadecimal_conversion:     
    
    add $a0, $zero, $t3                 
    add $a1, $zero, $s6                 
    lb $a2, 0($t5)                      

    jal subprogram_1                  
    
    add $t9, $t9, $v0                   

    
    addi $t5, $t5, 1                    
    addi $s6, $s6, 1                   
    
    blt $s6, $t3, hexadecimal_conversion     
  
  done:
    addi $sp, $sp, -4                  
    sw $t9, 0($sp)                      

    add $ra, $zero, $s5                 
    jr $ra

subprogram_3:           
    beq $a0, 1, printNan               
    beq $a0, 2, printLarge          
    beq $a0, 3, printDecimal          
    jr $ra

  printNan:

    la $a0, errormsg                                               
    li $v0, 4                                                                        
    syscall
    la $a0, 44                   
    li $v0, 11                                                                                           
    syscall
    jr $ra

  printLarge:
  
    la $a0, toobigmsg            
    li $v0, 4
    syscall
    la $a0, 44                   
    li $v0, 11                                                                                           
    syscall
    jr $ra

  printDecimal:
   

    addi $t1, $zero, 10000      
    lw $t2, 0($sp)                        
    addi $sp, $sp, 4                                      
     
    divu $t2, $t0                         
    mflo $t3                          
    mfhi $t4                            
    
    beq $t3, $zero, print_remainder     
    
  print_quotient:
    add $a0, $zero, $t3                                                      
    li $v0, 1                                                                                            
    syscall

  print_remainder:
    add $a0, $zero, $t4                                                         
    li $v0, 1                                                                 
    syscall
    la $a0, 44                   
    li $v0, 11                                                                                           
    syscall
    

    jr $ra
		