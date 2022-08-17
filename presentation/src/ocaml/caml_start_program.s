FUNCTION(G(caml_start_program))
CFI_STARTPROC
        CFI_SIGNAL_FRAME
    /* Save callee-save registers */
        PUSH_CALLEE_SAVE_REGS
    /* Load Caml_state into r14 (was passed as an argument from C) */
        movq    C_ARG_1, %r14
    /* Initial entry point is G(caml_program) */
        LEA_VAR(caml_program, %r12)
    /* Common code for caml_start_program and caml_callback* */
LBL(caml_start_program):
    /* Load young_ptr into %r15 */
        movq    Caml_state(young_ptr), %r15
    /* Build struct c_stack_link on the C stack */
        subq    $24 /* sizeof struct c_stack_link */, %rsp; CFI_ADJUST(24)
        movq    $0, Cstack_stack(%rsp)
        movq    $0, Cstack_sp(%rsp)
        movq    Caml_state(c_stack), %r10
        movq    %r10, Cstack_prev(%rsp)
        movq    %rsp, Caml_state(c_stack)
        CHECK_STACK_ALIGNMENT
    /* Load the OCaml stack. */
        movq    Caml_state(current_stack), %r11
        movq    Stack_sp(%r11), %r10
    /* Store the stack pointer to allow DWARF unwind */
        subq    $16, %r10
        movq    %rsp, 0(%r10) /* C_STACK_SP */
    /* Store the gc_regs for callbacks during a GC */
        movq    Caml_state(gc_regs), %r11
        movq    %r11, 8(%r10)
    /* Build a handler for exceptions raised in OCaml on the OCaml stack. */
        subq    $16, %r10
        lea     LBL(109)(%rip), %r11
        movq    %r11, 8(%r10)
    /* link in the previous exn_handler so that copying stacks works */
        movq    Caml_state(exn_handler), %r11
        movq    %r11, 0(%r10)
        movq    %r10, Caml_state(exn_handler)
    /* Switch stacks and call the OCaml code */
        movq    %r10, %rsp
        call    *%r12
LBL(108):
    /* pop exn handler */
        movq    0(%rsp), %r11
        movq    %r11, Caml_state(exn_handler)
        leaq    16(%rsp), %r10
1:  /* restore GC regs */
        movq    8(%r10), %r11
        movq    %r11, Caml_state(gc_regs)
        addq    $16, %r10
    /* Update alloc ptr */
        movq    %r15, Caml_state(young_ptr)
    /* Return to C stack. */
        movq    Caml_state(current_stack), %r11
        movq    %r10, Stack_sp(%r11)
        movq    Caml_state(c_stack), %rsp
        CFI_RESTORE_STATE
    /* Pop the struct c_stack_link */
        movq    Cstack_prev(%rsp), %r10
        movq    %r10, Caml_state(c_stack)
        addq    $24, %rsp; CFI_ADJUST(-24)
    /* Restore callee-save registers. */
        POP_CALLEE_SAVE_REGS
    /* Return to caller. */
        ret
LBL(109):
    /* Exception handler*/
    /* Mark the bucket as an exception result and return it */
        orq     $2, %rax
        /* exn handler already popped here */
        movq    %rsp, %r10
        jmp     1b
CFI_ENDPROC
ENDFUNCTION(G(caml_start_program))
