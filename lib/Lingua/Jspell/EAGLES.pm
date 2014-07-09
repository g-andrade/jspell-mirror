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
           . (exists($fea{CLA}) && $fea{CLA} eq "indef" ? "I":"A")
           . "0"
           . uc($fea{G})
           . uc($fea{N})
           . "0";
    },
	## --[ Números Cardinais ]--					
	card => sub {"Fixme(card)"},
	## --[ Números Ordinais ]--				
	nord => sub {"Fixme(nord)"},
	## --[ Pronomes Pessoais ]--				
	ppes => sub {
		my %fea = @_;
		my $tag = "PP";
		
		# pessoa (1,2,3)
		# género (M,F,Comum,Neutro)
		# Numero (S, P, N --impessoal/invariavel)
		# Caso (nominativo, acusativo, dativo, obliquo)
		# possuidor (Singluar, Plural)
		# Politeness 
	},
	## --[ Pronomes Possessivos ]--			
	ppos => sub {
		my %fea = @_;
		my $tag = "PX";
		
		# pessoa (1,2,3)
		# género (M,F,Comum,Neutro)
		# Numero (S, P, N --impessoal/invariavel)
		# Caso (nominativo, acusativo, dativo, obliquo)
		# possuidor (Singluar, Plural)
		# Politeness 
	},
	## --[ Pronomes Indefinido ]--		
	pind => sub {
		my %fea = @_;
		my $tag = "PI";
		
		# pessoa (1,2,3)
		# género (M,F,Comum,Neutro)
		# Numero (S, P, N --impessoal/invariavel)
		# Caso (nominativo, acusativo, dativo, obliquo)
		# possuidor (Singluar, Plural)
		# Politeness 
	},
	## --[ Pronomes Relativos ]--	
	prel => sub {
		my %fea = @_;
		my $tag = "PR";
		
		# pessoa (1,2,3)
		# género (M,F,Comum,Neutro)
		# Numero (S, P, N --impessoal/invariavel)
		# Caso (nominativo, acusativo, dativo, obliquo)
		# possuidor (Singluar, Plural)
		# Politeness 
	},
	## --[ Pronomes Demonstrativos ]--
	pdem => sub {
		my %fea = @_;
		my $tag = "PD";
		
		# pessoa (1,2,3)
		# género (M,F,Comum,Neutro)
		# Numero (S, P, N --impessoal/invariavel)
		# Caso (nominativo, acusativo, dativo, obliquo)
		# possuidor (Singluar, Plural)
		# Politeness 
	},
	## --[ Pronomes interrogativos ]--		
	pint => sub {
		my %fea = @_;
		my $tag = "PT";
		
		# pessoa (1,2,3)
		# género (M,F,Comum,Neutro)
		# Numero (S, P, N --impessoal/invariavel)
		# Caso (nominativo, acusativo, dativo, obliquo)
		# possuidor (Singluar, Plural)
		# Politeness 
	},
	## --[ Verbos ]--	
	v    => sub {
		my %fea = @_;
		my $tag = "V";

		# (XXX) tipo (principal, auxiliar, semiauxiliar...)
		$tag .= "0";

		# será que temos de adaptar estes 2 campos ao português?
		# Temos:
        ###        ip:  infinitivo pessoal
        ###        inf: infinitivo
        ###        pp:  pretérito perfeito
        ###        ppa: particípio passado
        ###        pc:  presente do conjuntivo
        ###        pic: pretérito imperfeito do conjuntivo
        ###        c:   condicional
        ###        p:   presente
        ###        fc:  futuro do conjuntivo
        ###        g:   gerúndio
        ###        pmp: pretérito mais que perfeito
        ###        pi:  pretérito imperfeito
        ###        f:   futuro
        ###        i:   imperativo		

        # (XXX)
		# modo: {I}ndicativo, {S}ubjuntivo, i{M}perativo, 
		#       i{N}finitivo, {G}erundio, {P}articipio
		$tag .= "0";

        # (XXX)
		# tempo: {P}resente, {I}mperfeito, {F}uturo, pas{S}ado, {C}ondicional
		$tag .= "0";

		# pessoa (1,2,3) -- 1_3 é desdobrado abaixo
		$tag .= exists($fea{P}) ? $fea{P} : "0";

		# numero (S, P)
		$tag .= exists($fea{N}) ? uc($fea{N}) : "0";

		# genero (M,F)
		$tag .= exists($fea{G}) ? uc($fea{G}) : "0";

		# Desdobrar pessoa.
		if ($tag =~ /1_3/) {
			my ($one, $three) = ($tag) x 2;
			$one   =~ s/1_3/1/;
			$three =~ s/1_3/3/;
			return ($one, $three)
		} else {
			return $tag;
		}
	},
	## --[ Preposições ]--	
	prep => sub { "SPS00" },
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
	cp   => sub {"Fixme(cp)"
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
		$grad =~ s/dim/D/i;
		$grad =~ s/aum/A/i;
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
		$grad =~ s/dim/D/i;
		$grad =~ s/aum/A/i;
		$grad = "0" unless $grad =~ /^[DA]$/;
		$tag .= $grad;

		return $tag;
	},
	## --[ Adjetivos ]--
	adj  => sub {
		my %fea = @_;
		my $tag = "A0";

		my $grad = $fea{GR};
		$grad =~ s/dim/D/i;
		$grad =~ s/aum/A/i;
		$grad =~ s/sup/S/i;
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
