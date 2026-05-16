.data
    # Tên file đầu vào và đầu ra
    fin:  .asciiz "C:/Users/Admin/Documents/TNKTMT/LAB3/raw_input.txt"
    fout: .asciiz "C:/Users/Admin/Documents/TNKTMT/LAB3/formatted_result.txt"

    # Các nhãn định dạng in ra
    title:   .asciiz "-Student personal information-\n"
    l_name:  .asciiz "Name: "
    l_id:    .asciiz "ID: "
    l_add:   .asciiz "Address: "
    l_age:   .asciiz "Age: "
    l_rel:   .asciiz "Religion: "

    # Bộ đệm tĩnh để chứa dữ liệu đọc và kết quả viết
    buffer_read:  .space 512
    buffer_write: .space 1024

.text
.globl main
main:
    # ----------------------------------------------------
    # BƯỚC 1: Mở và đọc file raw_input.txt
    # ----------------------------------------------------
    li $v0, 13
    la $a0, fin
    li $a1, 0          # Chế độ đọc (0: read)
    li $a2, 0
    syscall
    move $s0, $v0      # $s0 lưu file descriptor

    li $v0, 14
    move $a0, $s0
    la $a1, buffer_read
    li $a2, 512        # Đọc tối đa 512 bytes
    syscall
    move $s1, $v0      # $s1 lưu số lượng bytes thực tế đã đọc

    li $v0, 16         # Đóng file
    move $a0, $s0
    syscall

    # ----------------------------------------------------
    # BƯỚC 2: Cấp phát bộ nhớ động (Heap memory)
    # ----------------------------------------------------
    li $v0, 9
    move $a0, $s1
    addi $a0, $a0, 1   # Cấp phát = số bytes đọc được + 1 (cho ký tự null)
    syscall
    move $s2, $v0      # $s2 lưu địa chỉ đầu tiên của vùng nhớ Heap

    # ----------------------------------------------------
    # BƯỚC 3: Copy text từ file sang vùng nhớ Heap
    # ----------------------------------------------------
    la $t0, buffer_read
    move $t1, $s2
    move $t2, $zero
copy_to_heap:
    bge $t2, $s1, copy_done
    lb $t3, 0($t0)
    sb $t3, 0($t1)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    addi $t2, $t2, 1
    j copy_to_heap
copy_done:
    sb $zero, 0($t1)   # Kết thúc chuỗi trong Heap bằng ký tự null '\0'

    # ----------------------------------------------------
    # BƯỚC 4: Phân tách chuỗi từ Heap và định dạng
    # ----------------------------------------------------
    la $s3, buffer_write  # $s3 là con trỏ sẽ trượt trên buffer_write
    move $s4, $s2         # $s4 là con trỏ sẽ trượt trên vùng nhớ Heap

    # Thêm Tiêu đề
    la $a0, title
    jal append_str

    # Thêm Name
    la $a0, l_name
    jal append_str
    jal append_token

    # Thêm ID
    la $a0, l_id
    jal append_str
    jal append_token

    # Thêm Address
    la $a0, l_add
    jal append_str
    jal append_token

    # Thêm Age
    la $a0, l_age
    jal append_str
    jal append_token

    # Thêm Religion (Token cuối cùng không có dấu phẩy)
    la $a0, l_rel
    jal append_str
    jal append_token_last

    # ----------------------------------------------------
    # BƯỚC 5: In chuỗi ra Terminal và Ghi vào File
    # ----------------------------------------------------
    # In ra Terminal
    li $v0, 4
    la $a0, buffer_write
    syscall

    # Ghi vào file formatted_result.txt
    la $t0, buffer_write
    sub $t1, $s3, $t0     # Tính độ dài thực tế của chuỗi kết quả (bằng cách lấy địa chỉ cuối trừ địa chỉ đầu)

    li $v0, 13
    la $a0, fout
    li $a1, 1             # Chế độ ghi (1: write)
    li $a2, 0
    syscall
    move $s0, $v0         # $s0 lưu file descriptor

    li $v0, 15
    move $a0, $s0
    la $a1, buffer_write
    move $a2, $t1         # Số lượng byte cần ghi
    syscall

    li $v0, 16            # Đóng file đầu ra
    move $a0, $s0
    syscall

    # Kết thúc chương trình an toàn
    li $v0, 10
    syscall


# ====================================================
# CÁC HÀM CON (PROCEDURES) HỖ TRỢ XỬ LÝ CHUỖI
# ====================================================

# Hàm 1: Nối một chuỗi cố định vào buffer_write
# Đầu vào: $a0 chứa địa chỉ chuỗi cần nối
append_str:
    lb $t0, 0($a0)
    beq $t0, $zero, append_str_done
    sb $t0, 0($s3)
    addi $a0, $a0, 1
    addi $s3, $s3, 1
    j append_str
append_str_done:
    jr $ra

# Hàm 2: Trích xuất 1 thuộc tính từ Heap cho đến khi gặp dấu phẩy ','
append_token:
skip_space:
    lb $t0, 0($s4)
    li $t1, 32            # Bỏ qua khoảng trắng (space) đầu thuộc tính
    bne $t0, $t1, read_char
    addi $s4, $s4, 1
    j skip_space
read_char:
    lb $t0, 0($s4)
    beq $t0, $zero, token_done
    li $t1, 44            # Dừng nếu gặp dấu phẩy ','
    beq $t0, $t1, comma_found
    li $t1, 13            # Bỏ qua ký tự Carriage Return (\r)
    beq $t0, $t1, skip_char
    li $t1, 10            # Bỏ qua ký tự Line Feed (\n)
    beq $t0, $t1, skip_char

    sb $t0, 0($s3)        # Ghi ký tự hợp lệ vào buffer_write
    addi $s3, $s3, 1
skip_char:
    addi $s4, $s4, 1
    j read_char
comma_found:
    addi $s4, $s4, 1      # Nhảy qua dấu phẩy cho lần đọc tiếp theo
token_done:
    li $t0, 10            # Ghi ký tự xuống dòng '\n' ở cuối mỗi thuộc tính
    sb $t0, 0($s3)
    addi $s3, $s3, 1
    jr $ra

# Hàm 3: Trích xuất thuộc tính cuối cùng (Do không kết thúc bằng dấu phẩy)
append_token_last:
skip_space_last:
    lb $t0, 0($s4)
    li $t1, 32
    bne $t0, $t1, read_char_last
    addi $s4, $s4, 1
    j skip_space_last
read_char_last:
    lb $t0, 0($s4)
    beq $t0, $zero, token_last_done
    li $t1, 13            # Bỏ qua các ký tự xuống dòng bị thừa của file text cũ
    beq $t0, $t1, skip_char_last_2
    li $t1, 10
    beq $t0, $t1, skip_char_last_2

    sb $t0, 0($s3)
    addi $s3, $s3, 1
skip_char_last_2:
    addi $s4, $s4, 1
    j read_char_last
token_last_done:
    li $t0, 10            # Ghi xuống dòng cuối cùng
    sb $t0, 0($s3)
    addi $s3, $s3, 1
    jr $ra