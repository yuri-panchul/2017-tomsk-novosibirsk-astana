        .text
init:   li      $a0, 1          ## x = 1
        li      $v0, 0          ## calculation result reset
        li      $t0, 1          ## i = 1

fact:   add     $t0, $t0, 1     ## i++
        move    $t1, $0         ## x1 = 0
        move    $t4  $t0        ## i1 = i

L:      bez     $t4, $0   fact  ## if(i1 = 0) goto fact
        andi    $t3, $t4, 1     ##
        srl     $t4, $t4, 1     ## i1 >>= 1
        bez     $t3, $0,  L     ## if(t1 = 0) goto L
                                ## else 
        lui     $t2, $a0, $t0   ## t2  = x << i
        add     $t1, $t1, $t2   ## x1 += t2
        b       L               ## goto L