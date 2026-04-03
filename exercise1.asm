.data
    prompt: .asciiz "Nhap ten cua ban: "
    hello:  .asciiz "Hello, "
    excl:   .asciiz "!"
    name:   .space 50    

.text
main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 8
    la $a0, name
    li $a1, 50
    syscall

    li $v0, 4
    la $a0, hello
    syscall

    li $v0, 4
    la $a0, name
    syscall

    li $v0, 10
    syscall
