#!/usr/bin/perl

use strict;

package Build_PL;

use Module::Build ();

Module::Build
	-> new(
		module_name 		=> 'Salvation::Autotype',
		dist_abstract 		=> 'Salvation::Autotype itself',
		dist_author 		=> [ 'Gennadiy Filatov <kain.winterheart@gmail.com>' ],
		recursive_test_files 	=> 1,
		configure_requires	=> {
			'Module::Build' => 0.36
		},
		requires 		=> {
			'perl'		=> '>= 5.10.1',
'Moose' => '2.0402',
'Carp::Assert' => '0.20',

		}
	)
	-> create_build_script()
;

exit 0;

