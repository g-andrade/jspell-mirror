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

### AGREP
my $cc = ExtUtils::CBuilder->new();
my @agrep_source = qw~asearch.c asearch1.c bitap.c checkfile.c
                      compat.c  follow.c   main.c  maskgen.c
                      mgrep.c   parse.c    preprocess.c
                      sgrep.c   utilities.c~;
my @agrep_objects = map {$cc->compile(source => "agrep/$_")} @agrep_source;

$cc->link_executable(objects => [@agrep_objects], exe_file => "agrep/agrep");


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
