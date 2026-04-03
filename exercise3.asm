.data
    promptA: .asciiz "Insert a: "
    promptB: .asciiz "Insert b: "
    promptC: .asciiz "Insert c: "
    promptD: .asciiz "Insert d: "
    resF:    .asciiz "F = "
    resR:    .asciiz ", remainder "

.text
main:
    # 1. Nhập a, b, c, d và lưu vào các thanh ghi $s
    li $v0, 4
    la $a0, promptA
    syscall
    li $v0, 5
    syscall
    move $s0, $v0        # $s0 = a [cite: 47, 48]

    li $v0, 4
    la $a0, promptB
    syscall
    li $v0, 5
    syscall
    move $s1, $v0        # $s1 = b [cite: 47, 48]

    li $v0, 4
    la $a0, promptC
    syscall
    li $v0, 5
    syscall
    move $s2, $v0        # $s2 = c [cite: 47, 48]

    li $v0, 4
    la $a0, promptD
    syscall
    li $v0, 5
    syscall
    move $s3, $v0        # $s3 = d [cite: 47, 48]

    # 2. Tính Tử số: (a + 10) * (b - d) * (c - 2a) [cite: 45]
    addi $t0, $s0, 10    # $t0 = a + 10
    sub  $t1, $s1, $s3    # $t1 = b - d
    
    mul  $t2, $s0, 2     # $t2 = 2 * a
    sub  $t2, $s2, $t2    # $t2 = c - 2a
    
    mul  $t3, $t0, $t1    # $t3 = (a + 10) * (b - d)
    mul  $t3, $t3, $t2    # $t3 = Tử số (Tất cả nhân lại)

    # 3. Tính Mẫu số: a + b + c [cite: 46]
    add  $t4, $s0, $s1    # $t4 = a + b
    add  $t4, $t4, $s2    # $t4 = a + b + c

    # 4. Chia Tử số cho Mẫu số 
    div  $t3, $t4        # Lo = quotient, Hi = remainder
    mflo $s4             # Lưu thương số vào $s4
    mfhi $s5             # Lưu số dư vào $s5

    # 5. In kết quả 
    li $v0, 4
    la $a0, resF
    syscall              # In "F = "
    
    li $v0, 1
    move $a0, $s4
    syscall              # In Thương số
    
    li $v0, 4
    la $a0, resR
    syscall              # In ", remainder "
    
    li $v0, 1
    move $a0, $s5
    syscall              # In Số dư

    # Kết thúc
    li $v0, 10
    syscall