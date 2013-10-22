use strict;
use warnings;

use lib 't/';

package Salvation::Autotype::_tests::t00::Class;

use Moose;

use Salvation::Autotype;

has 'stuff'	=> ( is => 'rw', isa => autotype( 'Salvation::Autotype::Tests::T00C1' ), coerce => 1 );

no Moose;

package main;

use Test::More tests => 3;

subtest 'number' => sub
{
	plan tests => 6;

	ok( not( exists $INC{ 'Salvation/Autotype/Tests/T00C1.pm' } ), 'module is NOT loaded' );

	my $o1 = new_ok( 'Salvation::Autotype::_tests::t00::Class' => [ stuff => 100500 ] );

	ok( exists( $INC{ 'Salvation/Autotype/Tests/T00C1.pm' } ), 'module IS loaded automatically' );

	my $o2 = $o1 -> stuff();

	isa_ok( $o2, 'Salvation::Autotype::Tests::T00C1', 'stuff()' );

	is( $o2 -> id(), 100500, 'number matches' );

	is( $o1 -> stuff( 42 ) -> id(), 42, 'stuff( 42 ) -> id() is 42' );
};

subtest 'object' => sub
{
	plan tests => 2;

	my $o = Salvation::Autotype::Tests::T00C1 -> new( id => 0 );

	eval
	{
		my $o2 = Salvation::Autotype::_tests::t00::Class -> new( stuff => $o );

		is( $o2 -> stuff(), $o, 'stuff() is an object' );
		is( $o2 -> stuff( 42 ) -> id(), 42, 'stuff( 42 ) -> id() matches' );
	};
};

subtest 'wrong' => sub
{
	plan tests => 1;

	eval
	{
		my $o = Salvation::Autotype::_tests::t00::Class -> new( stuff => 0 );
		$o -> stuff( {} );
		fail();
	};

	eval
	{
		Salvation::Autotype::_tests::t00::Class -> new( stuff => {} );
		fail();
	};

	eval
	{
		my $o = Salvation::Autotype::_tests::t00::Class -> new( stuff => 0 );
		$o -> stuff( [] );
		fail();
	};

	eval
	{
		Salvation::Autotype::_tests::t00::Class -> new( stuff => [] );
		fail();
	};

	eval
	{
		my $o = Salvation::Autotype::_tests::t00::Class -> new( stuff => 0 );
		$o -> stuff( 'asd' );
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

