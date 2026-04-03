.data
    array:  .word 0:5
    prompt: .asciiz "Please input element "
    colon:  .asciiz ": "
    indexP: .asciiz "Please enter index: "

.text
main:
    li $t0, 0      
input_loop:
    beq $t0, 5, get_index

    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, colon
    syscall
    
 
    li $v0, 5
    syscall
    sll $t1, $t0, 2  # t1 = i * 4
    sw $v0, array($t1)
    
    addi $t0, $t0, 1
    j input_loop

get_index:
    li $v0, 4
    la $a0, indexP
    syscall
    li $v0, 5
    syscall
    
    sll $t1, $v0, 2
    lw $a0, array($t1)
    li $v0, 1
    syscall

    li $v0, 10
    syscall
