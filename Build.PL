use strict;
use warnings;

use lib 'inc';
use MyBuilder;

my $builder = MyBuilder->new
  (
   module_name    => 'Lingua::Jspell',
   license        => 'perl',
   dist_author    => ['Alberto Simões <ambs@cpan.org>',
                      'José João Almeida <jj@di.uminho.pt">',
                      'Ulisses Pinto'],
   needs_compiler => 1,
   build_requires => {
                      'File::Copy'         => '0',
                      'Config::AutoConf'   => '0.14',
                      'ExtUtils::CBuilder' => '0.27',
                      'Module::Build'      => '0.3603',
                      'File::Which'        => '0',
                      'Archive::Any'       => '0.0932',
                      'LWP::Simple'        => '0',
                      'Test::More'         => '0',
                      'IPC::Open2'         => '0',
                      'YAML::Any'          => '0.67',
                     },
   add_to_cleanup => [
                      'src/*.o',
                      'src/*.so',
                      'src/*.dylib',
                      'src/*.dll',
                      'Lingua-Jspell-*',
                     ],
  );

## HACK  HACK  HACK  HACK
my $libdir = $builder->install_destination("bin");
if ($^O =~ /mswin32/i) {
    $libdir = $ENV{WINDIR} || 'c:\\WINDOWS\\'; ## HACK HACK HACK
} else {
    $libdir =~ s/\bbin\b/lib/;
}

$builder->notes('lib_path' => $libdir);
$builder->add_build_element('usrlib');
$builder->install_path( 'usrlib' => $libdir );

$builder->create_build_script;
