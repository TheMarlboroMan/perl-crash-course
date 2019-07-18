use strict;
use warnings;
use feature "switch";

package controller_module_excercise;

#This module requires yet another one... Check it before continuing on.
use input_manager_exercise; 

#This module has no state. It makes no sense to have it as a class, but still
#we show that we can do it, even if its funcionality would be expressed more 
#concisely as a single subroutine "run"... Please, don't do this sort of thing
#in your real code.
sub new {

	my $class=shift;
	my $self;
	bless \$self, $class; 	#Yeah, you read that right, we blessed a scalar 
	return \$self;			#that is mostly undef.
}

#This is the main loop...
sub run {

	print "'exit' to finish\n";

	while(1){

		my @input=input_manager_exercise::get(">> ");
		next unless scalar @input;

		my $command=shift @input;
		last if $command eq "exit";

		my $res=undef;

		given($command) {
			$res=__list() when "list";
			$res=__delete(@input) when "delete";
			$res=__new(@input) when "new"; 
			$res=__add(@input) when "add";
			$res=__remove(@input) when "remove";
			$res=__set_name(@input) when "setname";
			$res=__set_address(@input) when "setaddress";
			$res=__by_name(@input) when "byname";
			$res=__by_address(@input) when "byaddress";
			$res=__by_phone(@input) when "byphone";
			default {
				print "Unknown operation '$_'\n";
			}
		}

		print defined $res ? "Last result: $res\n" : "Invalid result\n";
	}
}

#Validate that the count of items in the array @_[1] equals $_[0]...
sub __validate_input {

	my ($quantity, $params)=@_;
	if (scalar @$params != $quantity) {

		print "Invalid parameter count, expected $quantity, ", scalar @$params, " given\n";
		return 0;
	}

	return 1;
}

#And the rest is just glue... Lots and lots of glue.

sub __list {

	for (record_manager_exercise::get_records()) {
		print $_->describe(),"\n";
	}

	return 1;
}

#delete id
sub __delete {

	return if !__validate_input(1, \@_);
	return record_manager_exercise::delete_record(shift);
}

sub __new {

	#TODO: 
}

#add id phone
sub __add {

	return if !__validate_input(2, \@_);
}

#remove id phone
sub __remove {

	return if !__validate_input(2, \@_);
}

#setname id newname
sub __set_name {

	return if !__validate_input(2, \@_);
}

#setaddress id newaddress
sub __set_address {

	return if !__validate_input(2, \@_);
}

#byname string
sub __by_name {

	return if !__validate_input(1, \@_);
}

#byaddress string
sub __by_address {

	return if !__validate_input(1, \@_);
}

#byphone string
sub __by_phone {

	return if !__validate_input(1, \@_);
}

1
