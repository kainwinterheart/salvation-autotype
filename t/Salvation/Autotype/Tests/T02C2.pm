use strict;
use warnings;

package Salvation::Autotype::Tests::T02C2;

use Moose;

use Moose::Util::TypeConstraints;

coerce __PACKAGE__,
	from 'Int',
	via { __PACKAGE__ -> new( id => $_ ) };

no Moose::Util::TypeConstraints;

use Salvation::Autotype;

has 'id'	=> ( is => 'ro', isa => 'Int', required => 1 );

has 'class1'	=> ( is => 'rw', isa => autotype( 'Salvation::Autotype::Tests::T02C1' ), coerce => 1 );

no Moose;

-1;
