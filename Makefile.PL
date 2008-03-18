use strict;
use warnings;
use ExtUtils::MakeMaker;

use Config::AutoConf;
use ExtUtils::CBuilder;

# What do we need?

# 1. a C compiler
if (not Config::AutoConf->check_cc()) {
	die "I need a C compiler. Please install one!\n" 
}

# 2. ncurses
if (not Config::AutoConf->check_lib("ncurses", "tgoto")) {
	die "I need ncurses library. Please install it!\n" 	
}

## Get a C compiler
my $cc = ExtUtils::CBuilder->new();
my %c_config = (PREFIX => '/usr/local');

### AGREP
my @agrep_source = qw~asearch.c asearch1.c bitap.c checkfile.c
                      compat.c  follow.c   main.c  maskgen.c
                      mgrep.c   parse.c    preprocess.c
                      sgrep.c   utilities.c~;
my @agrep_objects = map {$cc->compile(source => "agrep/$_")} @agrep_source;
$cc->link_executable(objects => [@agrep_objects], exe_file => "agrep/agrep");

### JSpell
# first we need to get a YACC/Bison
# first let use luck and just "use" it
`cd src; yacc parse.y`;

## Take jsconfig.in and create jsconfig.h
open IN, "src/jsconfig.in" or die "Cannot open file [src/jsconfig.in] for reading.\n";
open H,  ">src/jsconfig.h" or die "Cannot create file [src/jsconfig.h] for writing.\n";
while(<IN>) {
	s/\[%\s*(\S+)\s*%\]/$c_config{$1}/ge;
	print H;
}
close H;
close IN;

my @jspell_source = qw~correct.c    good.c      jmain.c     makedent.c  tgood.c
                       defmt.c      hash.c      jslib.c     tree.c
                       dump.c       jbuild.c    jspell.c    sc-corr.c   xgets.c
                       gclass.c     jjflags.c   lookup.c    term.c      y.tab.c~;
my @jspell_objects = map {$cc->compile(
		extra_compiler_flags => '-DVERSION=\\"2.0\\"',
		source => "src/$_")} @jspell_source;
my @jspell_shared = grep {$_ !~ /jbuild|jmain/ } @jspell_objects;		

$cc->link_executable(extra_linker_flags => '-lncurses',
                     objects => [@jspell_shared,'src/jbuild.c'], 
                     exe_file => "src/jbuild");
$cc->link_executable(extra_linker_flags => '-lncurses',
                     objects => [@jspell_shared,'src/jmain.c'],  
                     exe_file => "src/jspell");



WriteMakefile(
    NAME                => 'Lingua::Jspell',
    AUTHOR              => 'Alberto Simões <ambs@di.uminho.pt>',
    VERSION_FROM        => 'lib/Lingua/Jspell.pm',
    ABSTRACT_FROM       => 'lib/Lingua/Jspell.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Lingua-Jspell-*' },
);
