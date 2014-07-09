package Lingua::Jspell::EAGLES;

# Mais uma vez, isto tudo é específico do português.
# algum código devia passar a ser baseado num YAML qualquer
# que defina a estrutura certa. 
#
# para já, não abrir demasiadas frentes.

my %rules = (
	## --[ Pronomes - Artigos ]--						
	art  => sub { my %fea = @_;
	  return "D"
             .($fea{CLA} eq "indef" ? "I":"A")
             ."0"
             .uc($fea{G})
             .uc($fea{N})
             . "0" ;
    },
	## --[ Números Cardinais ]--					
	card => sub {"Fixme"},
	## --[ Números Ordinais ]--				
	nord => sub {"Fixme"},
	## --[ Pronomes Pessoais ]--				
	ppes => sub {"Fixme"},
	## --[ Pronomes Possessivos ]--			
	ppos => sub {"Fixme"},
	## --[ Pronomes Indicativos ]--		
	pind => sub {"Fixme"},
	## --[ Pronomes Relativos ]--	
	prel => sub {"Fixme"},
	## --[ Pronomes Demonstrativos ]--
	pdem => sub {"Fixme"},
	## --[ Pronomes interrogativos ]--		
	pint => sub {"Fixme"},
	## --[ Verbos ]--	
	v    => sub {"Fixme"},
	## --[ Preposições ]--	
	prep => sub {"Fixme"},
	## --[ Advérbios ]--	
	adv  => sub {
		my %fea = @_;
		my $tag = "R";
		$tag .= exists($fea{SUBCAT}) && $fea{SUBCAT} eq "neg" ? "N" : "G";
		return $tag;
	},	
	## --[ Interjeições ]--	
	in   => sub { return "I" },	
	## --[ Conjunções ]--	
	con  => sub { return "C0" },	
	## --[ Contrações ]--
	cp   => sub {"???:Fixme"
		# temos de verificar se há CAT com cp...
	},
	## --[ Nomes Comuns ]--
	nc   => sub {
		my %fea = @_;
		my $tag = "NC";

		my $gen = uc($fea{G});
		$gen =~ s/[^MF]/C/i;
		$tag .= $gen;

		my $num = uc($fea{N});
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

		my $gen = uc($fea{G});
		$gen =~ s/[^MF]/C/;
		$tag .= $gen;

		my $num = uc($fea{N});
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
		$tag .= $grad;

		my $gen = uc($fea{G});
		$gen =~ s/[^MF]/C/;
		$tag .= $gen;

		my $num = uc($fea{N});
		$num =~ s/[^SP]/N/;
		$tag .= $num;

		return $grad . "0";
	},
	## --[ Nomes e Adjetivos ]--
	a_nc => sub {
		return ($rules{nc}->(@_), $rules{adj}->(@_))
	},
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
