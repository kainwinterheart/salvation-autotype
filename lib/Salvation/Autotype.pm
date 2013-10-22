use strict;
use warnings;

package Salvation::Autotype;

our $VERSION = 1.01;

use Moose;

use Moose::Exporter ();

use Salvation::Autotype::TypeConstraint ();

use Moose::Util::TypeConstraints ( 'register_type_constraint', 'find_type_constraint' );

Moose::Exporter -> setup_import_methods( with_meta => [ 'autotype' ] );

sub autotype
{
	my ( $meta, $class ) = @_;

	my $tc_name = sprintf( '%s::%s::For::%s', __PACKAGE__, $class, $meta -> name() );
	my $tc = find_type_constraint( $tc_name );

	unless( defined $tc )
	{
		$tc = Salvation::Autotype::TypeConstraint -> new(
			name => $tc_name,
			parent => find_type_constraint( 'Object' ),
			salvation_for_class => $class,
			constraint => sub
			{
				return $_ -> isa( $class );
			}
		);

		register_type_constraint( $tc );
	}

	return $tc_name;
}

no Moose;

-1;

