use strict;
use warnings;

package Salvation::Autotype::Tests::T03C1;

use Moose;

use Moose::Util::TypeConstraints;

coerce __PACKAGE__,
	from 'Int',
	via { __PACKAGE__ -> new( id => $_ ) };

no Moose::Util::TypeConstraints;

has 'id'	=> ( is => 'rw', isa => 'Int', required => 1 );

no Moose;

-1;

