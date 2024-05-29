.bss
arquivo: .skip 262159 
result: .skip 1

.data
input_file: .asciz "image.pgm"

.text
.globl _start


_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

main:
    jal open
    la a1, arquivo
    li a2, 262159
    li a7, 63           # syscall read (63)
    ecall 

    la a1, arquivo

    lbu t0, 3(a1)
    lbu t1, 4(a1)
    lbu t2, 5(a1)

    li t3, 32
    bne t1, t3, two_digit
        addi a2, t0, -48
        li a3, 11

        j one_digit
    two_digit:
        addi a2, t0, -48
        addi a3, t1, -48

        li t4, 10
        mul a2, a2, t4

        add a2, a2, a3
        li a3, 13
    one_digit:

    //a2 = size of the image
    //setCanvasSize
    move a0, a2
    move a1, a2
    li a7, 2201
    ecall

    //a3 = index of the start of the payload
    la a4, arquivo
    add a4, a4, a3


    li t0, 0
    loop:
    bge t0, a2, endloop
        li t1, 0
        innerloop:
        bge t1, a2, endinnerloop
            move a0, t0
            move a1, t1

            lbu t2, 0(a4)
            
            
            //next number
            addi a4, a4, 1

            addi t1, t1, 1
            j innerloop
        endinnerloop:
    
        addi t0, t0, 1
        j loop
    endloop:

open:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall
    ret

setPixel:
    li a0, 100 # x coordinate = 100
    li a1, 200 # y coordinate = 200
    li a2, 0xFFFFFFFF # white pixel
    li a7, 2200 # syscall setPixel (2200)
    ecall
    ret


write:
    li a0, 1
    la a1, result
    li a2, 1
    li a7, 64           # syscall write (64)
    ecall
    ret


   /* 
    li t0, 10
    div a3, a2, t0
    rem a4, a2, t0

    addi a3, a3, 48
    addi a4, a4, 48

    la a0, result
    li t0, 10
    sb a3, 0(a0)
    sb a4, 1(a0)
    sb t0, 2(a0)

    jal write

    li a0, 0
    li a7, 93 # exit
    ecall
    */