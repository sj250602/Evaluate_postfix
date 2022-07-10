.data                                     #defining our data here
	input1: .asciiz "Enter the Expression:"                    #printing statement for taking inut from computer  
	
	input2: .asciiz "\n"                                       # adding a newline character

	output: .asciiz "Final result of your postfix expression is:"    # this will be for printing our final answer

	len_exp: .space 1000                                           # defining len_exp by 1000 bytes space  i.e we will be taking less than 1000 in this
	
	plus: .byte '+'                                                # plus is operation addition
	
	minus: .byte '-'												#  minus is operation subtraction
	
	prdt: .byte '*'                                                 # prdt is operation product
	
	wrong_out: .asciiz "Given Postfix Expression is InCorrect!!!!!"      # when our given input postfix expression is wrong

.text                            # defining text section here

.globl main

main:                             # our main function starts from here
	
	li $v0,4                          # command call for printing string 
	la $a0,input1                       # loading input1 in a0 which is string
	syscall                              # calling the command for printing 
	
	li $v0,8                          # command call for reading of string in length
	la $a0,len_exp                      # loading len_exp in a0
	li $a1,1000                         # moving the value 1000 in a1
	syscall                               # calling the string reading
	
	lbu $t2,prdt                          #loading unsigned byte prdt in t2 , plus in t3 and minus in t4    
	lbu $t3,plus                             
	lbu $t4,minus
	la $t0,len_exp                         # loading len exp in temporary register t0
	li $t1,0                               # loas\ding the values 0 in all of t1, s4, s5
	li $s4,0
	li $s5,0
	stack:                          #  our stack starts from here
		
		lbu   $s0,0($t0)                      # loading unsigned byte of t0 in s0
		
		beqz $s0,exit		                 # if branch s0=0 then exit the program
		beq $s0,$t2,prdt_opr		            # if s0 = t2 then do prdt_opr
		beq $s0,$t3,plus_opr                      # if s0= t3 plus_opr
		beq $s0,$t4,minus_opr                        # if s0=t4 minus_opr
		beq $s0,10,exit                                 # if s0=10 then exit
		sub $s0,$s0,48                                       # if s0 = s0 -48 it is to convert char to int
		
		blt $s0,0,wrong_in                           # if s0<0 then go to wrong_in
		bgt $s0,9,wrong_in                                # if s0>9  then go to wrong_in
		sub $sp,$sp,4                                      #  the pointer of stack is moved by an offset of 4
		
		sw $s0,($sp)                                       # 
	
		addi $t0,$t0,1                                        # t0 = t0+1
		addi $t1,$t1,4                                           # t1 = t1+4
		addi $s4,$s4,1                                              #s4 = s4+1
		j     stack                                                     # jump stack
		
	plus_opr:                                           # our function plus_opr
		
		addi $s5,$s5,1                                    # s5 = s5+1
		beq $t1,0,wrong_in                                       #  if t1 =0  go to wrongin and also if t1 = 4 go to wrongin
		beq $t1,4,wrong_in
		
		lw $s1,0($sp)                              # loading the sp value in s1
		lw $s2,4($sp)                                # loading the sp+4 value in s2   
		addu $sp,$sp,8                              # our stack pointer added with offset of 8
		
		add $s1,$s1,$s2                              # storing s1+s2 in s1
		
		sub $sp,$sp,4                           # sp = sp-4 we have to move the reference before adding back that value           
		sw $s1,($sp)                         # loading s1 value in sp
		
		addi $t0,$t0,1                             #t0=t0+1
		sub $t1,$t1,4                               # t1 = t1 -4
		j     stack                                      # jump to stack
		
	minus_opr:                               #   our function minus opeartor
		
		addi $s5,$s5,1                        #     s5 = s5+1
		beq $t1,0,wrong_in                     #  if t1 = 0 or t1 = 4 go to wrongin
		beq $t1,4,wrong_in
		
		lw $s1,0($sp)                            #loading s1 and s2 in stack 
		lw $s2,4($sp)
		addu $sp,$sp,8                            #      stack refernce added by offset of 8
		
		sub $s1,$s2,$s1                            #        s1 = s2-s1
		
		sub $sp,$sp,4                               #          refernce of sp is subtracted by 4
		sw $s1,($sp)                                 #              loading back of s1 in sp
		
		addi $t0,$t0,1                                #              to=to+1
		sub $t1,$t1,4                                  #                     t1 = t1-4
		j     stack                                     #                      jump to stack
		
	prdt_opr:                                            #            our function product operator
		
		addi $s5,$s5,1                                    #             s5 = s5+1
		beq $t1,0,wrong_in                                 #                t1 = 0 and t1 =4 then go to wrong in
		beq $t1,4,wrong_in
		
		lw $s1,0($sp)                                           #   again same addoing the values in the stack 
		lw $s2,4($sp)                                                
		addu $sp,$sp,8   										#		our reference of stack is moved by an offset of 8
		
		mul $s1,$s1,$s2                                          #           s1 = s1*s2
		
		sub $sp,$sp,4                                             #     changing the refernce of stack as we are going to add an element
		sw $s1,($sp)                                                        
		
		addi $t0,$t0,1                                             #           t0 =t0+1
		sub $t1,$t1,4                                               #            t1 = t1 -4
		j     stack                                                  #                   jump from stack
		
	wrong_in:                                                         #our function wrongin
		
		li $v0,4                                                           #command for printing of an image 
		la $a0,wrong_out                                                    #    loading the wrongout in a0
		syscall                                                              #          calling the printing function
		
		li $v0,10                                                             #           exiting from the program
		syscall
		
exit:
	
	addi $s5,$s5,1                                                              #  s5 = s5+1
	bne $s5,$s4,wrong_in                                                         #    if s5 is not equal to s4 go to wrongin
	
	li $v0,4                                                                      #call for printing if the function
	la $a0,output                                                             #    loading output in a0
	syscall                                                                    #    calling the string for output
	
	li $v0,1                                                                  #    command for printing the integer
	lw $t4,($sp)                                                               # loading the value of stack in 
	move $a0,$t4                                                                # moving t4 contents to a0
	syscall                                                                      #calling the output
	
	li $v0,10                                                              #exiting from the program
	syscall