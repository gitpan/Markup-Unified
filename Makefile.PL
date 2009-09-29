use inc::Module::Install 0.77;

if ( -e 'MANIFEST.SKIP' ) {
    system( 'pod2text lib/Markup/Unified.pm > README' );
}

perl_version '5.008';

name 'Markup-Unified';
all_from 'lib/Markup/Unified.pm';

requires 'Moose';
requires 'Text::Textile' => 2.12;
requires 'Text::Markdown' => '1.0.25';
requires 'HTML::BBCode' => 2.06;

test_requires 'Test::More';

auto_install;
WriteAll;
