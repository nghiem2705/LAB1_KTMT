.data
    prompt_u: .asciiz "Please insert u: "
    prompt_v: .asciiz "Please insert v: "
    prompt_a: .asciiz "Please insert a: "
    prompt_b: .asciiz "Please insert b: "
    prompt_c: .asciiz "Please insert c: "
    prompt_d: .asciiz "Please insert d: "
    prompt_e: .asciiz "Please insert e: "
    const_2: .float 2.0
    const_6: .float 6.0
    const_7: .float 7.0

.text
.globl main
main:
    li $v0, 4
    la $a0, prompt_u
    syscall
    li $v0, 6
    syscall
    mov.s $f1, $f0   

    li $v0, 4
    la $a0, prompt_v
    syscall
    li $v0, 6
    syscall
    mov.s $f2, $f0   

    li $v0, 4
    la $a0, prompt_a
    syscall
    li $v0, 6
    syscall
    mov.s $f3, $f0   

    li $v0, 4
    la $a0, prompt_b
    syscall
    li $v0, 6
    syscall
    mov.s $f4, $f0   

    li $v0, 4
    la $a0, prompt_c
    syscall
    li $v0, 6
    syscall
    mov.s $f5, $f0   

    li $v0, 4
    la $a0, prompt_d
    syscall
    li $v0, 6
    syscall
    mov.s $f6, $f0   

    li $v0, 4
    la $a0, prompt_e
    syscall
    li $v0, 6
    syscall
    mov.s $f7, $f0   

    mul.s $f8, $f6, $f6     
    mul.s $f8, $f8, $f8     
    mul.s $f9, $f7, $f7     
    mul.s $f9, $f9, $f7     
    add.s $f10, $f8, $f9    

    mov.s $f0, $f1          
    jal calculate_F
    mov.s $f20, $f11        

    mov.s $f0, $f2          
    jal calculate_F
    mov.s $f21, $f11        

    sub.s $f12, $f20, $f21

    li $v0, 2
    syscall

    li $v0, 10
    syscall

calculate_F:
    mul.s $f14, $f0, $f0    
    mul.s $f15, $f14, $f14  
    mul.s $f16, $f15, $f14  
    mul.s $f17, $f16, $f0   

    lwc1 $f30, const_7
    mul.s $f18, $f3, $f17
    div.s $f18, $f18, $f30
    
    lwc1 $f30, const_6
    mul.s $f19, $f4, $f16
    div.s $f19, $f19, $f30
    
    lwc1 $f30, const_2
    mul.s $f22, $f5, $f14
    div.s $f22, $f22, $f30

    add.s $f11, $f18, $f19
    add.s $f11, $f11, $f22
    div.s $f11, $f11, $f10
    jr $ra