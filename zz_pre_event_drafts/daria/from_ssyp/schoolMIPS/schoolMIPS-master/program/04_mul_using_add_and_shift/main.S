        .text
init:   li      $a0, 3          ## x = 3
        li      $v0, 0          ## calculation result reset
        li      $t1, 1          ## y = 1

L:      move    $t0, $t1        ## m = y
        lui     $t0, $t0, 1     ## m <<= 1
        add     $t0, $t0, $t1   ## m += y 
        move    $t1, $t0        ## y = m
	move    $vo, $t1        ##return y 
        b       L               ## goto L        