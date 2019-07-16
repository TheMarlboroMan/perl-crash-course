#!/usr/bin/perl
use strict;
use warnings;

#Perl also supports inheritance through a slightly convoluted syntax (not that
#the OOP aspect of Perl is neccesarily clear to begin with). The first thing
#to do here is to open the "contact_revisited.pm" file, so we can understand
#what is going on here.
use contact_revisited;

my $NL="\n";

#Good, now let us do the stuff we did in the previous chapter... First, let us
#define a few subroutines. By the way, these are actually not good regarding
#coding practices, as they have unclear responsibilities. However, these 
#chapters are about  Perl and not about good coding. At least, we will pass
#the instance as a parameter this time...

sub print_id {
	my $instance=shift; #This will shadow the "$instance" in the global scope.
	print "The contact's ID is ", $instance->get_id(), $NL;
}

sub print_name {
	my $instance=shift;
	print "The contact's name is ", $instance->get_name(), $NL;
}

sub print_numbers {
	my $instance=shift;
	print "The contact's numbers are ", join(", ", $instance->get_numbers()), $NL;
}

sub print_address {
	my $instance=shift;
	print "The contact's address is ", $instance->get_address(), $NL;
}

sub change_and_print_name {
	my ($instance, $new_name)=@_;
	print "The new name is ", $instance->set_name($new_name), $NL;
}

sub add_and_print_number {
	my ($instance, $new_number)=@_;
	$instance->add_number($new_number);
	print "After additions, numbers are ", join(", ", $instance->get_numbers()), $NL;
}

sub remove_and_print_number {
	my ($instance, $number_to_remove)=@_;
	$instance->remove_number($number_to_remove);
	print "After removal, numbers are ", join(", ", $instance->get_numbers()), $NL;
}

sub change_and_print_address {
	my ($instance, $new_address)=@_;
	print "After address change, the address is ", $instance->set_address($new_address), $NL;
}

my $original_number=612534878;
my $instance=contact_revisited->new("John Doe", $original_number, "Green Avenue");

#Calling all subroutines now...
print_id($instance);
print_name($instance);
print_numbers($instance);
print_address($instance);
change_and_print_name($instance, "Mark Doe");
add_and_print_number($instance, 123456789);
remove_and_print_number($instance, $original_number);
change_and_print_address($instance, "Solitude Avenue 11");
print "Final state of the instance: ", $instance->describe, $NL;

#And just to demonstrate that the ID will increment itself...
my $instance_2=contact_revisited->new("Second person", 611475821, "Blues Street");
print "The second instance: ", $instance_2->describe, $NL;
