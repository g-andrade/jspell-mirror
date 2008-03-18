#!/usr/bin/perl

use warnings;
use strict;

use File::Copy;
use Config::AutoConf;
use ExtUtils::CBuilder;

# Gather some variables
my $VERSION = get_version();
my $prefix = get_prefix();

# Prepare a hash with variables for substitution on jsconfig.in
my %c_config = (PREFIX => $prefix);

# Show some information to the user about what are we doing.
print "Building International Jspell $VERSION.\n";
print "\nCompiling software for [$prefix].\n";

print "\nChecking for a working C compiler.\n";
if (not Config::AutoConf->check_cc()) {
	die "I need a C compiler. Please install one!\n" 
}

print "\nChecking for a working YACC processor.\n";
my $yacc;
if (!($yacc = Config::AutoConf->check_prog_yacc())) {
	die "I need one of bison, byacc or yacc. Please install one!\n" 	
}

print "\nChecking for a working ncurses library.\n";
if (not Config::AutoConf->check_lib("ncurses", "tgoto")) {
	die "I need ncurses library. Please install it!\n" 	
}



# prepare a C compiler
my $cc = ExtUtils::CBuilder->new();


### AGREP
print "\nCompiling agrep.\n";
my @agrep_source = qw~asearch.c    asearch1.c     bitap.c     checkfile.c
                      compat.c     follow.c       main.c       maskgen.c
                      mgrep.c      parse.c        preprocess.c
                      sgrep.c      utilities.c~;
my @agrep_objects = map {$cc->compile(source => "agrep/$_")} @agrep_source;
$cc->link_executable(objects => [@agrep_objects], exe_file => "agrep/agrep");

### JSpell
print "\nCompiling Jspell.\n";
# first we need to get a YACC/Bison
# first let use luck and just "use" it
my $cmd = "cd src; $yacc parse.y";
print "$cmd\n";
print `$cmd`;

## Take jsconfig.in and create jsconfig.h
open IN, "src/jsconfig.in" or die "Cannot open file [src/jsconfig.in] for reading.\n";
open H,  ">src/jsconfig.h" or die "Cannot create file [src/jsconfig.h] for writing.\n";
while(<IN>) {
	s/\[%\s*(\S+)\s*%\]/$c_config{$1}/ge;
	print H;
}
close H;
close IN;

open IN, "scripts/jspell-dict.in" or die "Cannot open file [...] for reading.\n";
open PL,  ">scripts/jspell-dict" or die "Cannot create file [...] for writing.\n";
while(<IN>) {
	s/\[%\s*(\S+)\s*%\]/$c_config{$1}/ge;
	print PL;
}
close PL;
close IN;


my @jspell_source = qw~correct.c    good.c      jmain.c     makedent.c  tgood.c
                       defmt.c      hash.c      jslib.c     tree.c
                       dump.c       jbuild.c    jspell.c    sc-corr.c   xgets.c
                       gclass.c     jjflags.c   lookup.c    term.c      y.tab.c~;
my @jspell_objects = map {$cc->compile(
		extra_compiler_flags => '-DVERSION=\\"'.$VERSION.'\\"',
		source => "src/$_")} @jspell_source;
my @jspell_shared = grep {$_ !~ /jbuild|jmain/ } @jspell_objects;		

$cc->link_executable(extra_linker_flags => '-lncurses',
                     objects => [@jspell_shared,'src/jbuild.c'], 
                     exe_file => "src/jbuild");

$cc->link_executable(extra_linker_flags => '-lncurses',
                     objects => [@jspell_shared,'src/jmain.c'],  
                     exe_file => "src/jspell");

print "\nBuilt International Jspell $VERSION.\n";

open TS, '>_jdummy_' or die ("Cant create timestamp [_jdummy_].\n");
print TS localtime;
close TS;
## Copy(from,to)
# This might change in the future
## %% my @executables = qw~src/jspell src/jbuild agrep/agrep~;
## %% 
## %% for my $exe (@executables) {
## %% 	chmod 0755, $exe;
## %% 	copy($exe, "blib/bin");
## %% }
## %% 
## 

sub get_prefix {
	my $prefix = undef;
	open MAKEFILE, "Makefile" or die "Cannot open file [Makefile] for reading\n";
	while(<MAKEFILE>) {
		if (m!^SITEPREFIX\s*=\s*(.*)$!) {
			$prefix = $1;
			last;
		}
	}
	close MAKEFILE;
	die "Could not find INSTALLSITEBIN variable on your Makefile.\n" unless $prefix;
	return $prefix;
}

sub get_version {
	my $version = undef;
	open PM, "lib/Lingua/Jspell.pm" or die "Cannot open file [lib/Lingua/Jspell.pm] for reading\n";
	while(<PM>) {
		if (m!^our\s+\$VERSION\s*=\s*'([^']+)'!) {
			$version = $1;
			last;
		}
	}
	close PM;
	die "Could not find VERSION on your .pm file. Weirdo!\n" unless $version;
}
