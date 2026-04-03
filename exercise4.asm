.data
    prompt: .asciiz "Please enter a positive integer less than 16: "
    result: .asciiz "Its binary form is: "

.text
main:

    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0       

    li $v0, 4
    la $a0, result
    syscall

    andi $t1, $t0, 8     
    srl  $a0, $t1, 3    
    li   $v0, 1
    syscall             

   
    andi $t1, $t0, 4    
    srl  $a0, $t1, 2
    li   $v0, 1
    syscall           

   
    andi $t1, $t0, 2   
    srl  $a0, $t1, 1    
    li   $v0, 1
    syscall              


    andi $a0, $t0, 1  
    li   $v0, 1
    syscall             


    li $v0, 10
    syscall