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
	'Dancer::Session::Storable' => 0,
    'Dancer::Plugin::Database' => 0,
    'DBD::mysql' => 0,
	'Dancer::Plugin::Nitesi' => 0.0032,
	'Template::Flute' => 0.0024,
	'Dancer::Template::TemplateFlute' => 0.0025,
	'Number::Format' => 0,
	'DateTime' => 0,
	'DateTime::Locale' => 0,
	'Input::Validator' => 0,
	'Business::OnlinePayment' => 3.01,
	'Moo' => 0.009013,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Flowers-*' },
);
