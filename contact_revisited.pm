use strict;
use warnings;

#The "package" keyword identifies our package. Remember, classes are packages.
package contact_revisited;

#This package will make use of the "contact" package we already have and extend 
#it with two new data fields (and its corresponding methods), an unique 
#identifier and a "home address".

#We need to use the "use" and "parent" keywords to establish a relationship 
#between this package and its parent package:

use parent qw(contact);

#This scalar will be the id for newly created entries... The module itself will
#keep count of it.
my $current_id=0;

#The constructor... Let us go step by step on this one...
sub new {
	#First, we get the data we need: remember that $class is "automatic".
	my ($class, $name, $phone, $address)=@_;

	#Wel call the parent's new subroutine. It will return a blessed reference
	#to the base object... The syntax here is "SUPER", class is 
	#"contact_revisited" so we are actually creating a new instance of 
	#"contact" by doing contact_revisited->PARENT::new.
	my $data=$class->SUPER::new($name, $phone);

	#Now we increment the id and add it to the blessed reference.
	my $id=++$current_id;
	$data->{id}=$id;
	$data->{address}=$address;

	#And finally return the reference.
	return $data;
}

#The unique id for each instance will not have a setter, only a getter.
sub get_id {
	my $data=shift;
	return $data->{id};
}

#Now the addresses...
sub get_address{
	my $data=shift;
	return $data->{address};
}

sub set_address{
	my ($data, $new_address)=@_;
	$data->{address}=$new_address;
}

#And an overloaded version of "describe"...
sub describe {
	my $data=shift;
	my $original=$data->SUPER::describe;
	return "[", $data->{id}, "] ", $original, " (", $data->{address}, ")";
}

#As always, return a true value from a module.
1;
