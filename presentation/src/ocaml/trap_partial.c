struct ocaml_trap {
	/* Something explained later */
	void*	something;
	/* Pointer to the handler code */
	void*	handler;
};

void touch_trap(struct ocaml_trap* trap)
{
	trap->something = (void*)0x1;
	trap->handler = (void*)0x2;
}

int main(void)
{
	struct ocaml_trap trap = {
		.something = (void*)0xCAFECAFE,
		.handler = (void*)0xDEADBEEF
	};
	touch_trap(&trap);
	return 0;
}
