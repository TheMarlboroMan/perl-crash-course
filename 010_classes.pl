#!/usr/local/perl
use strict;
use warnings;

#Classes and OOP in Perl are a bit weird. Before going on here, let's take a 
#look at the file "contact.pm", because classes are implemented as modules...

use contact;

my $NL="\n";
my $original_number=666123653;

#Instancing a class is easy: just use the constructor method (new, by 
#convention)...
my $instance=contact->new("John Doe", $original_number);
print $instance, $NL;

sub print_name {

	#Method invocation follows the arrow operator.	
	print "The contact's name is ", $instance->get_name(), $NL;
}

sub print_numbers {

	print "The contact's numbers are ", join(", ", $instance->get_numbers()), $NL;
}

sub change_and_print_name {

	my $new_name=shift;
	print "The new name is ", $instance->set_name($new_name), $NL;
}

sub add_and_print_number {
	$instance->add_number(shift);
	print "After additions, numbers are ", join(", ", $instance->get_numbers()), $NL;
}

sub remove_and_print_number {
	$instance->remove_number(shift);
	print "After removal, numbers are ", join(", ", $instance->get_numbers()), $NL;
}

#Remember, there's more than one way to call a subroutine...
&print_name;
print_numbers();
change_and_print_name("Mark Doe");
add_and_print_number(123456789);
remove_and_print_number($original_number);
print "Final state of the instance: ", $instance->describe, $NL;
