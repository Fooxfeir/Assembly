.globl _start

_start:
    jal main
    exit:
    li a0, 0
    li a7, 93 # exit
    ecall


main:

    jal read 

    li a7, 0
    loop:

        li t1, 4
        bge a7, t1, endloop

        la a0, input_address
        li t1, 5

        mul t2, t1, a7
        add a0, t2, a0
        
        lbu t1, 0(a0)
        lbu t2, 1(a0)
        lbu t3, 2(a0)
        lbu t4, 3(a0)

        addi t1, t1, -48
        addi t2, t2, -48
        addi t3, t3, -48
        addi t4, t4, -48

        li t5, 1000
        mul t1, t1, t5
        
        li t5, 100
        mul t2, t2, t5

        li t5, 10
        mul t3, t3, t5

        add a1, t1, t2
        add a1, a1, t3
        add a1, a1, t4

        li t5, 2
        div a2, a1, t5 # a2 = k, a1 = y

        li a6, 0
        for:
            li t1, 10
            bge a6, t1, cont

            li t5, 2

            div a3, a1, a2 # a3 = y / k
            add a4, a2, a3 
            div a2, a4, t5

            addi a6, a6, 1
            j for
        cont:

        mv a1, a2

        li t5, 1000
        div t1, a1, t5
        rem a1, a1, t5

        li t5, 100
        div t2, a1, t5
        rem a1, a1, t5

        li t5, 10
        div t3, a1, t5
        rem a1, a1, t5

        li t5, 1
        div t4, a1, t5

        addi t1, t1, 48
        addi t2, t2, 48
        addi t3, t3, 48
        addi t4, t4, 48

        li a1, 3
        bge a7, a1, ultima
        li t5, 32
        j outra
        ultima:
        li t5, 10
        outra:


        la a0, result
        li a1, 5
        mul a1, a7, a1

        add a0, a1, a0
        sb t1, 0(a0)
        sb t2, 1(a0)
        sb t3, 2(a0)
        sb t4, 3(a0)
        sb t5, 4(a0)

        addi a7, a7, 1
        j loop

    endloop:
    jal write
    jal exit

read:
    li a0, 0            # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 20           # size - Reads 20 bytes.
    li a7, 63           # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 20           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret


.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20