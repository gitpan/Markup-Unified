#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Markup::Unified' );
}

diag( "Testing Markup::Unified $Markup::Unified::VERSION, Perl $], $^X" );
