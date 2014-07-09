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
	nc   => sub {
		my %fea = @_;
		my $tag = "NC";

		my $gen = $fea{G};
		$gen =~ s/[^MF]/C/;
		$tag .= $gen;

		my $num = $fea{N};
		$num =~ s/[^SP]/N/;
		$tag .= $num;

		# tipo de nome
		$tag .= "00";

		my $grad = $fea{GR};
		$grad =~ s/dim/D/;
		$grad =~ s/aum/A/;
		$grad = "0" unless $grad =~ /^[DA]$/;

		$tag .= $grad;
	},
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