use strict;
use warnings;
use ExtUtils::MakeMaker;

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
