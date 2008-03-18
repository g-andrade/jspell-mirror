use strict;
use warnings;
use ExtUtils::MakeMaker;

unlink "_jdummy_";

WriteMakefile(
    NAME                => 'Lingua::Jspell',
    AUTHOR              => 'Projecto Natura',
    VERSION_FROM        => 'lib/Lingua/Jspell.pm',
    ABSTRACT_FROM       => 'lib/Lingua/Jspell.pm',
    PL_FILES            => {},
    PREREQ_PM => {
		'Config::AutoConf' => 0.05,
		'ExtUtils::CBuilder' => 0.22,
		'File::Which' => 0,
        'Test::More' => 0,
    },
	EXE_FILES           => ['src/jspell','src/jbuild','agrep/agrep', 'scripts/jspell-dict'],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Lingua-Jspell-*' },
);


package MY; # so that "SUPER" works right
sub top_targets {
    my $inherited = shift->SUPER::top_targets(@_);
    $inherited =~ s!^(config\s*::.*)$!$1 jspell!m;
    $inherited;
}

sub postamble {
    return <<'MAKE_FRAG';
jspell: _jdummy_
	$(NOECHO) $(NOOP)
	
_jdummy_:
	$(PERL) scripts/build.pl

MAKE_FRAG
}