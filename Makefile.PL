use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Flowers',
    AUTHOR              => q{Stefan Hornburg (Racke) <racke@linuxia.de>},
    VERSION_FROM        => 'lib/Flowers.pm',
    ABSTRACT_FROM       => 'lib/Flowers.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    BUILD_REQUIRES => {
	'Test::More' => 0,
    },
    PREREQ_PM => {
        'YAML'       => 0,
        'Dancer'     => 1.3080,
	'Dancer::Session::DBIC' => 0,
    'Dancer::Plugin::Database' => 0,
    'Dancer::Plugin::Auth::Extensible' => 0,
    'DBD::mysql' => 0,
	'Dancer::Plugin::Interchange6' => 0.006,
	'Dancer::Template::TemplateFlute' => 0.0092,
	'Number::Format' => 0,
	'DateTime' => 0,
	'DateTime::Locale' => 0,
	'Input::Validator' => 0,
	'Business::OnlinePayment' => 3.01,
	'Moo' => 0.009013,
    'DBIx::Class' => 0,
    'Dancer::Plugin::DBIC' => 0,
    'Interchange6::Schema' => 0.012,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Flowers-*' },
);
