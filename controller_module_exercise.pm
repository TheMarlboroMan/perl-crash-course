use strict;
use warnings;
use feature "switch";

package controller_module_exercise;

#This module requires yet another one... Check it before continuing on.
use input_manager_exercise; 

#It also requires this module for the last subroutine (__new)... This is done
#in purpose: input_manager_exercise (which we just required) requires 
#"input_module" too, but does not import it into the global scope.
use input_module;

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

	print "'exit' to finish, 'help' for commands\n";

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
			$res=$this->__help() when "help";
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

#A quick print thing... See that syntax? That's call "heredoc". Two < signs, 
#and a customer delimiter, then, everything you write will preserve its format,
#newlines and tabs included. When you want to be done, just write your custom
#delimiter on its own line.
sub __help {

	print <<DELIMITER
Available commands:
	-help
	-list
	-delete [id]
	-new
	-add [id phone]
	-remove [id phone]
	-setname [id newvalue]
	-setaddress [id newvalue]
	-byname [find]
	-byaddress [find]
	-byphone[find]

DELIMITER
;

	return 1;
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

#Glue...
sub __delete {

	my $this=shift;
	return if !__validate_input(1, @_);
	return $this->{rm}->delete_record(shift);
}

#Even more glue...
sub __add {

	my $this=shift;
	return if !__validate_input(2, @_);
	return $this->{rm}->add_phone_to_record(shift, shift);
}

#Some more glue...
sub __remove {

	my $this=shift;
	return if !__validate_input(2, @_);
	#Learn from my mistakes... See how this subroutine is called "__remove"?
	#well, the subroutine in the supporting module is called "delete_xxxx". You
	#should strive to keep a consistent approach to your names.
	return $this->{rm}->delete_phone_from_record(shift, shift);
}

#And more glue...
sub __set_name {

	my $this=shift;
	return if !__validate_input(2, @_);
	return $this->{rm}->update_record(shift, "name", shift);
}

#A bit more of glue...
sub __set_address {

	my $this=shift;
	return if !__validate_input(2, @_);
	return $this->{rm}->update_record(shift, "address", shift);
}

#The next three are glue depending on a deeper glue thing...
sub __by_name {

	my $this=shift;
	return $this->__find_and_print("name", @_);
}

sub __by_address {

	my $this=shift;
	return $this->__find_and_print("address", @_);
}

sub __by_phone {

	my $this=shift;
	return $this->__find_and_print("numbers", @_);
}

#Common glue find...
sub __find_and_print {

	my $this=shift;
	my $type=shift;

	return if !__validate_input(1, @_);
	my @res=$this->{rm}->find_records($type, shift);
	
	if(! scalar @res) {
		print "No data found\n";
		return 1;
	}

	for(@res) {
		print $_->describe(), "\n";
	}

	return 1;
}

#This is the only subroutine that is a bit different from the rest, because it
#must prompt for different pieces of data. It is, however, trivial:

sub __new {

	my $this=shift;

	print "Enter name (empty to cancel)";
	#This is very nice and compact.
	return 2 if !length(my $name=input_module::get_input());

	print "Enter address (empty to cancel)";
	return 2 if !length(my $address=input_module::get_input());

	print "Enter phone (empty to cancel)";
	return 2 if !length(my $phone=input_module::get_input());

	return $this->{rm}->create_record($name, $address, $phone);
}

1
