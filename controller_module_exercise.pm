use strict;
use warnings;
use feature "switch";

package controller_module_exercise;

#This module requires yet another one... Check it before continuing on.
use input_manager_exercise; 

#Constructor: its only state is the record_manager. Providing it to the 
#constructor instead of creating it inside the constructor is a form of
#dependency injection.
sub new {

	my ($class, $record_manager)=@_;
	my $self={rm => $record_manager};

	#Extra syntax fun: with no return, whatever is evaluated from the last
	#statement is returned, in this case $self.
	bless $self, $class;
}

#This is the main loop...
sub run {

	my $this=shift;

	print "'exit' to finish\n";

	while(1){

		my @input=input_manager_exercise::get(">> ");
		next unless scalar @input;

		my $command=shift @input;
		last if $command eq "exit";

		my $res=undef;

		#Take heed: arguments will be sent not as a reference to the array in
		#$_[0], but as $_[0], $_[1] and so on, because we are not sending 
		#a reference!. Inside these methods we will call __validate_input,
		#in which we will do the same: append a value to the beginning and 
		#send them flattened again. Is that a good thing?. I don't know: franky,
		#seems harder to read and that's always bad but I want to cover many
		#ways of doing things...
		given($command) {
			$res=$this->__list() when "list";
			$res=$this->__delete(@input) when "delete";
			$res=$this->__new(@input) when "new"; 
			$res=$this->__add(@input) when "add";
			$res=$this->__remove(@input) when "remove";
			$res=$this->__set_name(@input) when "setname";
			$res=$this->__set_address(@input) when "setaddress";
			$res=$this->__by_name(@input) when "byname";
			$res=$this->__by_address(@input) when "byaddress";
			$res=$this->__by_phone(@input) when "byphone";
			default {
				print "Unknown operation '$_'\n";
			}
		}

		print defined $res ? "Last result: $res\n" : "Invalid result\n";
	}
}

#Validate that the count of items in the array @_[1] equals $_[0]...
sub __validate_input {

	#We remove the first item: that's the quantity. It must be the same as the
	#sum of the rest.
	my $quantity=shift;
	if (scalar @_ != $quantity) {

		print "Invalid parameter count, expected $quantity, ", scalar @_, " given\n";
		return 0;
	}

	return 1;
}

#And the rest is just glue... Lots and lots of glue.

sub __list {

	my $this=shift;
	for ($this->{rm}->get_records()) {
		print $_->describe(),"\n";
	}

	return 1;
}

#delete id
sub __delete {

	my $this=shift;
	return if !__validate_input(1, @_);
	return $this->{rm}->delete_record(shift);
}

#add id phone
sub __add {

	my $this=shift;
	return if !__validate_input(2, @_);
	return $this->{rm}->add_phone_to_record(shift, shift);
}

#remove id phone
sub __remove {

	return if !__validate_input(2, @_);
	return $this->{rm}->remove_phone_from_record(shift, shift);
}

#setname id newname
sub __set_name {

	my $this=shift;
	return if !__validate_input(2, @_);
	return $this->{rm}->update_record(shift, "name", shift);
}

#setaddress id newaddress
sub __set_address {

	my $this=shift;
	return if !__validate_input(2, @_);
	return $this->{rm}->update_record(shift, "address", shift);
}

#byname string
sub __by_name {

	return if !__validate_input(1, @_);
}

#byaddress string
sub __by_address {

	return if !__validate_input(1, @_);
}

#byphone string
sub __by_phone {

	return if !__validate_input(1, @_);
}

sub __new {

	#TODO: 
}

1
