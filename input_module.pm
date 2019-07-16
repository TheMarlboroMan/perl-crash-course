#!/usr/bin/perl

#This is always good.
use strict;
use warnings;

#This is going to be a separate module... The filename input_module
#will be essential to call it... Anyhow, first, declare the package.
package input_module;

#This package will be used to get data from the standard input. It will have a 
#global variable with the used prompt and two subroutines: one that sets the
#prompt and other that displays the prompt and uses it.

#Globals inside a module are only accessible inside the module so this variable 
#cannot be read from the inside.
my $prompt=">>";

#Subroutines will be accesible from the outside... There is no notion of 
#private subroutines so, as in other languages, we can use underscores to 
#indicate that stuff should not be used...
sub set_prompt {

	$prompt=$_[0] if(scalar @_ == 1);
}

sub get_input {

	&__print_prompt;
	my $input=<STDIN>;
	chomp $input;
	return $input;
}

#These underscores are screaming "Do not call this from outside this module!".
sub __print_prompt {

	print $prompt;
}

#For backwards compatibility reasons we put this here. This will return a 
#truish value to other programs using our module...
1;
