use strict;
use warnings;

package Salvation::Autotype::TypeConstraint;

use Moose;

use Module::Load ();

use Moose::Util::TypeConstraints ();

use Moose::Meta::TypeCoercion ();

use Carp::Assert ();

extends 'Moose::Meta::TypeConstraint';

has 'salvation_for_class'	=> ( is => 'ro', isa => 'Str', required => 1 );

has 'salvation_coercion'	=> ( is => 'ro', isa => 'CodeRef', lazy => 1, builder => '__build_salvation_coercion' );

has 'salvation_type_coercion_map'	=> ( is => 'ro', isa => 'ArrayRef', lazy => 1, builder => '__build_salvation_type_coercion_map' );

has 'salvation_type_coercion'	=> ( is => 'ro', isa => 'Moose::Meta::TypeCoercion', lazy => 1, builder => '__build_salvation_type_coercion' );

sub __build_salvation_coercion
{
	my $self = shift;

	my $class = $self -> salvation_for_class();

	return sub
	{
		my @rest = @_;

		&Module::Load::load( $class );

		my $tc = &Moose::Util::TypeConstraints::find_type_constraint( $class );

		&Carp::Assert::assert( defined( $tc ), sprintf( 'There is no type constraint for "%s"', $class ) );

		return $tc -> coerce( @rest );
	};
}

sub __build_salvation_type_coercion_map
{
	my $self = shift;

	return [
		'Any',
		$self -> salvation_coercion()
	];
}

sub __build_salvation_type_coercion
{
	my $self = shift;

	return Moose::Meta::TypeCoercion -> new(
		type_coercion_map => $self -> salvation_type_coercion_map()
	);
}

around 'coercion' => sub
{
	my ( $orig, $self, @rest ) = @_;

	return $self -> salvation_type_coercion();
};

around 'has_coercion' => sub
{
	return 1;
};


no Moose;

__PACKAGE__ -> meta() -> make_immutable(
	inline_constructor => 0
);

-1;

