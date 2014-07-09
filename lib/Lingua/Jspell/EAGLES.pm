package Lingua::Jspell::EAGLES;

# Mais uma vez, isto tudo é específico do português.
# algum código devia passar a ser baseado num YAML qualquer
# que defina a estrutura certa. 
#
# para já, não abrir demasiadas frentes.

my %rules = (
	art  => sub {},
	card => sub {},
	nord => sub {},
	ppes => sub {},
	ppos => sub {},
	pind => sub {},
	prel => sub {},
	pdem => sub {},
	pint => sub {},
	nc   => sub {},
	np   => sub {},
	adj  => sub {},
	a_nc => sub {},
	v    => sub {},
	);

sub _cat2eagles {
	my %fea = @_;

	if (exists($rules{$fea{CAT}})) {
		return $rules{$fea{CAT}}->(%fea);
	} else {
		return "_UNK"
	}
}


1;