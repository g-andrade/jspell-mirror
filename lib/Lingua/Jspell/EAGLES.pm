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
	## --[ Nomes Comuns ]--
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

		return $tag;
	},
	## --[ Nomes Próprios ]--
	np   => sub {
		my %fea = @_;
		my $tag = "NP";

		my $gen = $fea{G};
		$gen =~ s/[^MF]/C/;
		$tag .= $gen;

		my $num = $fea{N};
		$num =~ s/[^SP]/N/;
		$tag .= $num;

		my $sem = $fea{SEM} || "V0";
		$sem = "SP" if $sem eq "p";
		$tag .= $sem;

		my $grad = $fea{GR};
		$grad =~ s/dim/D/;
		$grad =~ s/aum/A/;
		$grad = "0" unless $grad =~ /^[DA]$/;
		$tag .= $grad;

		return $tag;
	},
	## --[ Adjetivos ]--
	adj  => sub {
		my %fea = @_;
		my $tag = "A0";

		my $grad = $fea{GR};
		$grad =~ s/dim/D/;
		$grad =~ s/aum/A/;
		$grad =~ s/sup/S/;
		$grad = "0" unless $grad =~ /^[DSA]$/;
		$tag .= $grad

		my $gen = $fea{G};
		$gen =~ s/[^MF]/C/;
		$tag .= $gen;

		my $num = $fea{N};
		$num =~ s/[^SP]/N/;
		$tag .= $num;

		return $grad . "0";
	},
	## --[ Nomes e Adjetivos ]--
	a_nc => sub {
		return ($rules{nc}->(@_), $rules{adj}->(@_))
		},
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