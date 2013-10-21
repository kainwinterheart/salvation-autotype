use strict;
use warnings;

package Salvation::Autotype::TypeConstraint;

use Moose;

use Module::Load ();

use Moose::Util::TypeConstraints ();

use Carp::Assert ();

extends 'Moose::Meta::TypeConstraint';

has 'salvation_for_class'	=> ( is => 'ro', isa => 'Str', required => 1 );

around 'coerce' => sub
{
	my ( $orig, $self, @rest ) = @_;

	my $class = $self -> salvation_for_class();

	&Module::Load::load( $class );

	my $tc = &Moose::Util::TypeConstraints::find_type_constraint( $class );

	&Carp::Assert::assert( defined( $tc ), sprintf( 'There is no type constraint for "%s"', $class ) );

	return $tc -> coerce( @rest );
};

no Moose;

__PACKAGE__ -> meta() -> make_immutable(
	inline_constructor => 0
);

-1;

