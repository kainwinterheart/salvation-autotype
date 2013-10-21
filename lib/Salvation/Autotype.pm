use strict;
use warnings;

package Salvation::Autotype;

our $VERSION = 1.00;

use Moose;

use Moose::Exporter ();

use Salvation::Autotype::TypeConstraint ();

use Moose::Util::TypeConstraints ( 'class_type', 'register_type_constraint', 'find_type_constraint' );

use Moose::Meta::TypeCoercion ();

Moose::Exporter -> setup_import_methods( with_meta => [ 'autotype' ] );

sub autotype
{
	my ( $meta, $class ) = @_;

	my $tc_name = sprintf( '%s::%s::For::%s', __PACKAGE__, $class, $meta -> name() );
	my $tc = find_type_constraint( $tc_name );

	unless( defined $tc )
	{
		my $class_tc = class_type( $class );

		$tc = Salvation::Autotype::TypeConstraint -> new(
			name => $tc_name,
			parent => $class_tc,
			salvation_for_class => $class,
			coercion => Moose::Meta::TypeCoercion -> new()
		);

		register_type_constraint( $tc );
	}

	return $tc_name;
}

no Moose;

-1;

