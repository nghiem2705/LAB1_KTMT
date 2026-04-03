.data
    my_array: .word 1, 2, 5, 8, 12, 44, 3, 9, 0, 10
    space:    .asciiz ", "

.text
main:
    li $t0, 9

reverse_loop:
    blt $t0, 0, end_loop

    sll $t1, $t0, 2

    lw $a0, my_array($t1)
    li $v0, 1
    syscall

    beq $t0, 0, skip_space
    li $v0, 4
    la $a0, space
    syscall

skip_space:
    addi $t0, $t0, -1
    j reverse_loop

end_loop:
    li $v0, 10
    syscall