#!/usr/bin/perl

#This is always good.
use strict;
use warnings;

#This is going to be a separate module... The filename input_module
#will be essential to call it... Anyhow, first, declare the package.
package input_module;

#Globals inside a module are only accessible inside the module so this variable 
#cannot be read from the inside.
my $prompt=">>";

#Subroutines will be accesible from the outside...
sub set_prompt {

	$prompt=$_[0] if(scalar @_ == 1);
}

sub get_input {
	print $prompt;
	my $input=<STDIN>;
	chomp $input;
	return $input;
}

#For backwards compatibility reasons we put this here. This will return a 
#truish value to other programs using our module...
1;
