
        .text

init:   li      $a0, 3          ## x = 3
        li      $v0, 0          ## calculation result reset
       
        li      $t0, 1          ## y = 1
        
L:      mul     $t0, $a0        ## y *= x
        move    $v0, $t0        ## return y
        b       L               ## goto L
