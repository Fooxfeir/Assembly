.bss 
linha_1: .skip 12
linha_2: .skip 20
X_c: .skip 4
Y_b: .skip 4
T_r: .skip 4
T_a: .skip 4
T_b: .skip 4
T_c: .skip 4
string: .skip 12


.text
.globl _start


_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall


main:
    la a1, linha_1
    li a2, 12
    jal read

    la a0, linha_1
    li a1, 0
    jal numerifica_com_sinal
    la t0, X_c
    sw a0, 0(t0)

    la a0, linha_1
    li a1, 6
    jal numerifica_com_sinal
    la t0, Y_b
    sw a0, 0(t0)

    la a1, linha_2
    li a2, 20
    jal read

    la a0, linha_2
    li a1, 0
    jal numerifica_sem_sinal
    la t0, T_r
    sw a0, 0(t0)

    la a0, linha_2
    li a1, 5
    jal numerifica_sem_sinal
    la t0, T_a
    sw a0, 0(t0)

    la a0, linha_2
    li a1, 10
    jal numerifica_sem_sinal
    la t0, T_b
    sw a0, 0(t0)

    la a0, linha_2
    li a1, 15
    jal numerifica_sem_sinal
    la t0, T_c
    sw a0, 0(t0)


    la t1, T_b
    lw a0, 0(t1)
    la a1, string
    li a2, 32
    li a3, 0
    jal desnumerifica


    la t1, T_c
    lw a0, 0(t1)
    la a1, string
    li a2, 10
    li a3, 6
    jal desnumerifica

    la a1, string
    li a2, 12
    jal write

    li a0, 0
    li a7, 93 # exit
    ecall


# recebe um endereco em a0 e o índice em a1
# devolve o numero em a0
numerifica_com_sinal:
    add a0, a0, a1 # move o ponteiro para o indice
    lbu t0, 0(a0) # guarda o sinal
    lbu t1, 1(a0)
    lbu t2, 2(a0)
    lbu t3, 3(a0)
    lbu t4, 4(a0)

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

    add a0, t1, t2
    add a0, a0, t3
    add a0, a0, t4

    li t1, 45
    bne t0, t1, positivo
    li t1, -1
    mul a0, a0, t1
    positivo:
    ret


# recebe um endereco em a0 e o índice em a1
# devolve o numero em a0
numerifica_sem_sinal:
    add a0, a0, a1 # move o ponteiro para o indice
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

    add a0, t1, t2
    add a0, a0, t3
    add a0, a0, t4

    ret

# recebe um inteiro de 4 dígitos em a0
# recebe o endereço de escrita em a1
# recebe o valor do fim da string em a2
# recebe o índice de escrita em a3
# retorna uma string sinalizada com os caracteres em ascii
desnumerifica:
    addi a5, a0, 0

    bge a0, zero, if
    li t1, -1
    mul a0, a0, t1
    if:

    li t5, 1000
    div t1, a0, t5
    rem a0, a0, t5

    li t5, 100
    div t2, a0, t5
    rem a0, a0, t5

    li t5, 10
    div t3, a0, t5
    rem a0, a0, t5

    li t5, 1
    div t4, a0, t5

    addi t1, t1, 48
    addi t2, t2, 48
    addi t3, t3, 48
    addi t4, t4, 48

    add a1, a1, a3
    
    sb t1, 1(a1)
    sb t2, 2(a1)
    sb t3, 3(a1)
    sb t4, 4(a1)
    
    bge a5, zero, positivo_
    li t0, 45
    sb t0, 0(a1)
    sb a2, 5(a1)
    ret

    positivo_:
    li t0, 43
    sb t0, 0(a1)
    sb a2, 5(a1)
    ret


read:
    li a0, 0            # file descriptor = 0 (stdin)
    li a7, 63           # syscall read (63)
    ecall
    ret


write:
    li a0, 1            # file descriptor = 1 (stdout)
    li a7, 64           # syscall write (64)
    ecall
    ret


.bss


result: .skip 0x20
