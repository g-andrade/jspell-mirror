
int mkstemp (char *template) {
	return __gen_tempname (template, 0, 0);
}

