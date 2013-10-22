use strict;
use warnings;

use lib 't/';

package main;

use Salvation::Autotype::Tests::T02C1 ();

use Test::More tests => 2;

subtest 'autoload c2 from c1' => sub
{
	plan tests => 5;

	ok( not( exists $INC{ 'Salvation/Autotype/Tests/T02C2.pm' } ), 'module is NOT loaded' );

	my $o1 = new_ok( 'Salvation::Autotype::Tests::T02C1' => [ id => 1, class2 => 2 ] );

	ok( exists( $INC{ 'Salvation/Autotype/Tests/T02C2.pm' } ), 'module IS loaded automatically' );

	my $o2 = $o1 -> class2();

	isa_ok( $o2, 'Salvation::Autotype::Tests::T02C2', 'class2()' );

	is( $o2 -> id(), 2, 'number matches' );
};

subtest 'test c2 after it has been loaded from c1' => sub
{
	plan tests => 3;

	my $o1 = new_ok( 'Salvation::Autotype::Tests::T02C2' => [ id => 2, class1 => 1 ] );

	my $o2 = $o1 -> class1();

	isa_ok( $o2, 'Salvation::Autotype::Tests::T02C1', 'class1()' );

	is( $o2 -> id(), 1, 'number matches' );
};

exit 0;

