use strict;
use warnings;

use lib 't/';

package Salvation::Autotype::_tests::t01::Class;

use Moose;

use Salvation::Autotype;

has 'stuff'	=> ( is => 'ro', isa => sprintf( '%s|Undef|HashRef', autotype( 'Salvation::Autotype::Tests::T01C1' ) ), coerce => 1 );

no Moose;

package main;

use Test::More tests => 5;


subtest 'number' => sub
{
	plan tests => 5;

	ok( not( exists $INC{ 'Salvation/Autotype/Tests/T01C1.pm' } ), 'module is NOT loaded' );

	my $o1 = new_ok( 'Salvation::Autotype::_tests::t01::Class' => [ stuff => 100500 ] );

	ok( exists( $INC{ 'Salvation/Autotype/Tests/T01C1.pm' } ), 'module IS loaded automatically' );

	my $o2 = $o1 -> stuff();

	isa_ok( $o2, 'Salvation::Autotype::Tests::T01C1', 'stuff()' );

	is( $o2 -> id(), 100500, 'number matches' );
};

subtest 'undef' => sub
{
	plan tests => 1;

	eval
	{
		ok( not( defined( Salvation::Autotype::_tests::t01::Class -> new( stuff => undef ) -> stuff() ) ), 'stuff() is undefined' );
	};
};

subtest 'hashref' => sub
{
	plan tests => 2;

	eval
	{
		my $h = { a => 1, b => 2 };

		is_deeply( Salvation::Autotype::_tests::t01::Class -> new( stuff => $h ) -> stuff(), { a => 1, b => 2 }, 'stuff() is hash' );
		is( Salvation::Autotype::_tests::t01::Class -> new( stuff => $h ) -> stuff(), $h, 'stuff() is the same ref' );
	};
};

subtest 'object' => sub
{
	plan tests => 1;

	my $o = Salvation::Autotype::Tests::T01C1 -> new( id => 0 );

	eval
	{
		is( Salvation::Autotype::_tests::t01::Class -> new( stuff => $o ) -> stuff(), $o, 'stuff() is an object' );
	};
};

subtest 'wrong' => sub
{
	plan tests => 1;

	eval
	{
		Salvation::Autotype::_tests::t00::Class -> new( stuff => [] );
		fail();
	};

	eval
	{
		Salvation::Autotype::_tests::t00::Class -> new( stuff => 'asd' );
		fail();
	};

	ok( $@, 'wrong types do not match' );
};


exit 0;

