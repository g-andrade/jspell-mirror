#!/usr/bin/perl

use warnings;
use strict;

use File::Copy;
use Config::AutoConf;
use ExtUtils::CBuilder;

# Gather some variables
my $VERSION = get_version();

interpolate('src/jsconfig.in','src/jsconfig.h',%c_config);
interpolate('scripts/jspell-dict.in','scripts/jspell-dict',%c_config);
interpolate("scripts/ujspell.in","scripts/ujspell",%c_config);
interpolate('scripts/installdic.in','scripts/installdic.pl',%c_config);
interpolate('jspell.pc.in','jspell.pc',%c_config);


sub get_prefix {
	my $make_cmd = shift;
	my $prefix = undef;
	open PATH, "-|", "$make_cmd -s printprefix" or die "Can't execute '$make_cmd printprefix'!\n";
	chomp($prefix = <PATH>);
	close PATH;
	die "Could not find INSTALLSITEBIN variable on your Makefile.\n" unless $prefix;
	$prefix=~s/\\/\//g;
	return $prefix;
}
