#!/usr/bin/perl
use strict;
use warnings;

#Modules are Perl's way of isolating sets of subroutines in reusable packages.
#Before going on with this file, open and read the file input_module.pm

#Now that you read that, see how we "import" the module...
use input_module;

sub echo {
	print "You wrote ", $_[0], "\n";
}

#And the rest is easy: the :: syntax is used to access module stuff...
my $retval=input_module::get_input();
echo $retval;

input_module::set_prompt("**");
echo input_module::get_input();
