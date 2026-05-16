.data
    prompt_a:    .asciiz "Please insert a: "
    prompt_b:    .asciiz "Please insert b: "
    prompt_c:    .asciiz "Please insert c: "
    msg_no_sol:  .asciiz "There is no real solution\n"
    msg_one_sol: .asciiz "There is one solution, x="
    msg_x1:      .asciiz "x1="
    msg_x2:      .asciiz " and x2="
    f_zero:      .float 0.0
    f_two:       .float 2.0
    f_four:      .float 4.0

.text
.globl main
main:
    li $v0, 4
    la $a0, prompt_a
    syscall
    li $v0, 6
    syscall
    mov.s $f1, $f0

    li $v0, 4
    la $a0, prompt_b
    syscall
    li $v0, 6
    syscall
    mov.s $f2, $f0

    li $v0, 4
    la $a0, prompt_c
    syscall
    li $v0, 6
    syscall
    mov.s $f3, $f0

    lwc1 $f4, f_four
    lwc1 $f5, f_two
    lwc1 $f6, f_zero

    mul.s $f7, $f2, $f2
    mul.s $f8, $f4, $f1
    mul.s $f8, $f8, $f3
    sub.s $f7, $f7, $f8

    c.lt.s $f7, $f6
    bc1t no_solution
    
    c.eq.s $f7, $f6
    bc1t one_solution

    sqrt.s $f8, $f7
    mul.s $f9, $f5, $f1
    neg.s $f10, $f2
    
    sub.s $f11, $f10, $f8
    div.s $f12, $f11, $f9
    
    add.s $f13, $f10, $f8
    div.s $f14, $f13, $f9

    li $v0, 4
    la $a0, msg_x1
    syscall
    
    li $v0, 2
    syscall
    
    li $v0, 4
    la $a0, msg_x2
    syscall
    
    li $v0, 2
    mov.s $f12, $f14
    syscall
    
    j exit_program

one_solution:
    neg.s $f10, $f2
    mul.s $f9, $f5, $f1
    div.s $f12, $f10, $f9

    li $v0, 4
    la $a0, msg_one_sol
    syscall
    
    li $v0, 2
    syscall
    j exit_program

no_solution:
    li $v0, 4
    la $a0, msg_no_sol
    syscall

exit_program:
    li $v0, 10
    syscall