lw $a2,0($a1)
lb $a2,0($a2)
addi $a2,$a2,-48

hash_fn:

addi $sp, $sp, -12      # open stack
sw $s5, 0($sp)          # preserve $s5
sw $s6, 4($sp)          # preserve $s6
sw $s7, 8($sp)          # preserve $s7

addi $t8,$zero,247      #$t8=247
srl $s4,$a2,24 
andi $s4,$s4,0x000000ff #first 8-bits 

srl $s5,$a2,16
andi $s5,$s5,0x000000ff #second 8-bits

srl $s6,$a2,8
andi $s6,$s6,0x000000ff #third 8-bits

andi $s7,$a2,0x000000ff #fourth 8-bits

xori $s4,$s4,0x00000065
andi $s4,$s4,0x000000ff
add $t0, $zero, $s4
jal poly 

xor $s5,$s5,$v0
andi $s5,$s5,0x000000ff
add $t0, $zero, $s5
jal poly

xor $s6,$s6,$v0
andi $s6,$s6,0x000000ff
add $t0, $zero, $s6
jal poly

xor $s7,$s7,$v0
andi $s7,$s7,0x000000ff
add $t0, $zero, $s7
jal poly

add $s0, $zero, $v0
lui $t9, 0x1001  
sw   $s0,0($t9)

  # Restore $s5, $s6, $s7 from the stack
    lw $s5, 0($sp)          # Restore $s5
    lw $s6, 4($sp)          # Restore $s6
    lw $s7, 8($sp)          # Restore $s7
    addi $sp, $sp, 12       # Free stack space

  addi $v0, $zero, 10    
        syscall                    

 poly:
        # Save $ra and $t1
        addi $sp, $sp, -8      # store in the stack 
        sw $ra, 4($sp)         # Save return address
        sw $t1, 0($sp)         # Save $t1 (counter)

        addi $t1, $zero, 0     # Initialize counter
        addi $t2, $zero, 0     # Initialize accumulator

    start:
        bne $t0, $t1, L1
        sll $t3, $t2, 5        # 32 * X^2
        sll $t4, $t2, 3        # 8 * X^2
        add $t5, $t3, $t4      # 40 * X^2
        add $t5, $t5, $t2      # 41 * X^2
        j start2

    L1:
        add $t2, $t2, $t0    # Accumulate $s3 into $t2
        addi $t1, $t1, 1       # Increment counter
        j start

    start2:
        sll $t6, $t0, 3        # 8 * X
        sll $t7, $t0, 2        # 4 * X
        add $t6, $t6, $t7      # 12 * X
        add $t6, $t6, $t0      # 13 * X
        add $v0, $t6, $t5       #[41*(X^2)+13*X]
        sub $v0, $t8, $v0      # 247 - [41*(X^2)+13*X]
        andi $v0, $v0,0xFF    # Mask to lower 8 bits

        # Restore $ra and $t1 before returning
        lw $t1, 0($sp)         # Restore $t1
        lw $ra, 4($sp)         # Restore return address
        addi $sp, $sp, 8       # reset stack pointer
        jr $ra               















