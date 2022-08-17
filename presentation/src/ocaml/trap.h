struct ocaml_trap {
	/* Pointer to the next (previous) trap */
	struct ocaml_trap* next;
	/* Pointer to the handler code */
	void* handler;
};
