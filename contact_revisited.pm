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
$current_id=0;

#The constructor... Let us go step by step on this one...
sub new {
	#First, we get the data we need: remember that $class is "automatic".
	my ($class, $name, $phone)=@_;

	#Wel call the parent's new subroutine. It will return a blessed reference
	#to the base object... The syntax here is "SUPER", class is 
	#"contact_revisited" so we are actually creating a new instance of 
	#"contact" by doing contact_revisited->PARENT::new.
	my $data=$class->SUPER::new $name, $phone;

	#Now we increment the id and add it to the blessed reference.
	my $id=++$current_id;
	$data->{id}=$id;

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
	my $data=shit;
	return $data->{address};
}

sub set_address{
	my ($data, $new_address)=@_;
	$data->{address}=$_new_address;
}

#As always, return a true value from a module.
1;
