                    .text                                                # FinishSemantics
                    .globl      __start                                  # FinishSemantics
__start:                                                                 # FinishSemantics
                    jal         _main                                    # FinishSemantics
                    li          $v0         10                           # FinishSemantics
                    syscall                                              # FinishSemantics
_rec:                                                                    # func entry
                    subu        $sp         $sp         4                # ProcFuncBody
                    sw          $ra         0($sp)                       # ProcFuncBody
                    li          $v0         4                              
                    la          $a0         L1                             
                    syscall                                                
                    lw          $t0         _x                             
                    li          $v0         1                              
                    move        $a0         $t0                            
                    syscall                                                
                    li          $v0         4                              
                    la          $a0         L2                             
                    syscall                                                
                    lw          $t0         _x                             
                    li          $t1         1                              
                    sub         $t2         $t0         $t1                
                    sw          $t2         _x                             
                    lw          $t0         _x                             
                    li          $t1         0                              
                    beq         $t0         $t1         L3                 
                    jal         _rec                                     # CallFunc
                    b           L5                                       # ProcIf
L3:                                                                      # ProcIf
                    li          $v0         4                              
                    la          $a0         L4                             
                    syscall                                                
L5:                                                                      # ProcIf
                    lw          $t0         _x                             
                    li          $t1         1                              
                    add         $t3         $t0         $t1                
                    sw          $t3         _x                             
                    li          $v0         4                              
                    la          $a0         L6                             
                    syscall                                                
                    lw          $t0         _x                             
                    li          $v0         1                              
                    move        $a0         $t0                            
                    syscall                                                
                    li          $v0         4                              
                    la          $a0         L2                             
                    syscall                                                
rec_ret:                                                                   
                    lw          $ra         0($sp)                       # ProcFuncBody
                    addu        $sp         $sp         4                # ProcFuncBody
                    jr          $ra                                      # func return
_main:                                                                   # func entry
                    subu        $sp         $sp         4                # ProcFuncBody
                    sw          $ra         0($sp)                       # ProcFuncBody
                    li          $v0         4                              
                    la          $a0         L7                             
                    syscall                                                
                    li          $v0         5                            # read int syscall
                    syscall                                                
                    move        $t0         $v0                            
                    sw          $t0         _x                             
                    jal         _rec                                     # CallFunc
                    li          $v0         4                              
                    la          $a0         L8                             
                    syscall                                                
main_ret:                                                                  
                    lw          $ra         0($sp)                       # ProcFuncBody
                    addu        $sp         $sp         4                # ProcFuncBody
                    jr          $ra                                      # func return
                    .data                                                # FinishSemantics
_x:                 .word       0                                          
L6:                 .asciiz     "exit  x = "                               
L4:                 .asciiz     "      x = 0\n"                               
L7:                 .asciiz     "> "                                       
L2:                 .asciiz     "\n"                                       
L1:                 .asciiz     "enter x = "                               
L8:                 .asciiz     "done\n"                                   
