use strict;
use warnings;

use lib 't/';

package Salvation::Autotype::_tests::t03::Class;

use Moose;

use Salvation::Autotype;

has 'stuff'	=> ( is => 'ro', isa => autotype( 'Salvation::Autotype::Tests::T03C1' ), coerce => 1, handles => { stuff_id => 'id' } );

no Moose;

package main;

use Test::More tests => 3;

my $o = new_ok( 'Salvation::Autotype::_tests::t03::Class' => [ stuff => 100500 ] );

is( $o -> stuff() -> id(), 100500, 'stuff() -> id(): number matches' );
is( $o -> stuff_id(), 100500, 'stuff_id(): number matches' );

exit 0;

