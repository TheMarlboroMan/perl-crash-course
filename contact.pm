use strict;
use warnings;

#This will be our class file. A class is implemented as a package, so, like
#in the previous example, let us start by defining a package.
package contact;

#We will use a subroutine "first index of" located in the module "arraytools".
#You can take a look at it now if you want by checking the arraytools.om file.
use arraytools qw(first_index_of);

#Before starting, let us define what we want our class to be: it will be part
#of a concact book, where every contact has a name, and list of phone numbers.
#We will provide an interface to get, add and remove phone numbers, along with
#getters and setters for the name.

#There is no specific class syntax per se: what Perl expects us to do is to
#have a subroutine that acts as a constructor and that works in a very, very
#specific fashion. No naming convention is enforced, but let us be consistent
#and use "new"...

#This is our "constructor" subroutine. For ease of use, let us assume that 
#our constructor class expects two arguments: the first will be a string (the 
#name) and the second will be a number (the phone number)... Yes, I know that
#phone numbers might contain dashes, pluses and stuff, but let's keep this 
#simple..
sub new {
	#Interesting bit: calling shift with nothing uses @_ as the first argument...
	#Second interesting bit: the first argument is implicitly the class name,
	#so the other arguments are the ones we want.
	my $class=shift;
	my $name=shift;
	my $phone=shift;
	my @numbers=($phone);

	#You are free to choose your internal implementation for class data. Here I
	#will choose a map... Notice how the numbers will be stored as a reference.
	#to this local array.
	my %data=(name => $name, numbers => \@numbers);

	#And now for the funky part. Blessing: this hurts, but it basically says
	#that data shall be from now on associated with the classname and will be
	#our instance.
	bless \%data, $class;

	#Finally the instance is returned... There is something interesting here:
	#nothing stops the class client to access our data structure directly: it's
	#only an agreement that clients should use the public interface provided
	#by the module. Anyhow, there are techniques to enforce encapsulation,
	#but let's keep this simple...
	return \%data;

	#One VERY important thing: we have chosen here to create a data hash and 
	#then bless a reference to it and returning it... It would have been much
	#easier to just do my $data={name => $name, numbers => \@numbers}, hence
	#directly creating a reference to a hash thanks to the curly bracket syntax.
}

#Now, let's do our getters... All methods are subroutines...

sub get_name {
	#When calling a method, the first parameter is expected to be whatever that
	#was blessed in the constructor, so...
	my $data=shift;
	$data->{name}; #In the face of no return statement, the last statement is returned...
}

sub set_name {
	my $data=shift;
	return $data->{name}=shift;
}

sub get_numbers {
	my $data=shift;
	return @{$data->{numbers}}
}

#This needs no explanation: push to the array...
sub add_number {
	my $data=shift;
	push @{$data->{numbers}}, shift;
}

#This will remove the number passed as a parameter if it can find it. Will
#return true in that case... 
sub remove_number {
	my ($data, $search)=@_;

	my $index=arraytools::first_index_of \@{$data->{numbers}}, $search;
	return 0 if -1==$index;

	#Splice removes elements from the first argument, starting at the second,
	#as many as indicated by the third.
	splice @{$data->{numbers}}, $index, 1;
	return 1;
}

sub describe {
	my $data=shift;
	return $data->{name}." ".join(", ", $data->get_numbers());
}

#Remember to return a true value from your modules!
1;