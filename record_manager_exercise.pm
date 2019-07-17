use strict;
use warnings;

#As long as we are at it, Perl hackers are used to having their modules with
#CamelCase naming. We will just use underscores.
package record_manager_exercise;

#The record manager will be a class that will keep and interact with records.
#Based on the exercise text, we have come with the following list of methods:

# set_filename
# read_records
# find_records (by id, name, address or phone)
# save_records_to_file
# delete_record
# update_record (updates name or address)
# create_record
# add_phone_to_record
# delete_phone_from_record

#These methods will be the "public" interface for this class. The private 
#interface will be any other helper methods we may come accross.

#First off, we need the contact_revisited module!
use contact_revisited;

#And we will need some storage for the contacts. There we go, an empty array.
my @_contacts=();
my $_filename="";

#We can now begin to build subroutines. This will set the filename for all
#save and load operations...
sub set_filename {
	$_filename=shift;
}

#This one encapsulates reading data from the given file or the default filename.
sub read_records {
	
	if(!length $_filename) {
		print "Filename must be set, exiting\n";
		die;
	}

	#Try to load from the good file or the default file...
	if(!_read_records_from_file($_filename)) {

		print "Could not find $_filename, loading defaults...\n";
		if(!_read_records_from_file("resources/sample_records.txt")) {
			print "Could not read records from default file. Exiting\n";
			die; #Die will stop our program.
		}

		print "Saving defaults to real file...\n";
		record_manager_exercise::save_records_to_file($_filename);
	}

	#Actually, it might be bad that our routines have these sort of secondary
	#effects, such as printing to the stdout... Consider that your real 
	#subroutines should do one thing and one thing only!.
	print scalar @_contacts, " records loaded...\n";
}

#This is the the private subroutine to read records from the file.  It will take 
#the filename as a parameter and fill up @_contacts with the data. If we cannot 
#open the file, we will return a false value. 
sub _read_records_from_file {

	my $filename=shift;

	return 0 unless open(my $handle, "<", $filename);

	#Just because we can, let us empty the storage, in case we want to call this
	#suboutine more than once.
	@_contacts=();
	while(<$handle>) {

		 #Remove the newline and get parameters from the file...
		chomp $_;
		my ($id, $name, $address, $phones)=split '#', $_;

		#Do we have a repeated id?
		if(scalar find_records("id", $id)) {
			close $handle;
			print "Found repeated id $id, exiting\n";
			die;
		}

		my @phones=split ',', $phones;
		my $record=contact_revisited->new($name, shift  @phones, $address, $id);

		#As long as there are phones left, add them...
		for (@phones) {
			$record->add_number($_); #This is another $_ than the one above...
		}

		#Add the contact to the records...
		push @_contacts, $record;
	}

	close $handle;
	return 1;
}

#This subroutine will take two values: the first is a string indicating the
#"field" we are searching, and the second indicates the value we search. The
#subroutine will return undef if cannot find anything, or an array of results.
#There is a third parameter, it. It will be passed along when we want to get
#the index of the result.
sub find_records {

	my ($field, $value, $it)=@_;

	$it=0 if defined $it;

	my @results;

	for my $current (@_contacts) {
		if($field eq "id") {
			if($current->get_id() == $value) {
				push @results, $current;
				last; #No need to keep going, we have only 1 value per id.
			}
		}
		#This is ugly, but we can use strings to call subroutines...
		elsif($field eq "name" or $field eq "address") {

			#Compose the method name and call it...
			my $methodname="get_".$field;
			#A bit of regex magic...
			if($current->$methodname() =~ /$value/) {
				push @results, $current;
			}
		}
		elsif($field eq "phone") {
			#The phone case is slightly different, but easy too
			my $phones=join ",", $current->get_numbers();
			if($phones =~ /$value/) {
				push @results, $current;
			}
		}
		else {
			print "Unknown field '$field' to 'find_records', exiting\n";
			die();
		}

		#Perls parameters are passed by reference, so the caller can get 
		#the index of the result by checking $it.
		++$it if defined $it;
	}

	return @results;
}

#This one is easy too... It will get the filename as a parameter and dump the
#records according to the format specified in the exercise. In case of failure
#to write, the program will exit.
sub save_records_to_file {

	my $filename=shift;
	my $handle;
	if(!open($handle, ">", $filename)) {
		print "Could not save to $filename... exiting\n";
		die;
	}

	for(@_contacts) {
		my @data=($_->get_id(),
			$_->get_name(),
			$_->get_address(),
			join ",", $_->get_numbers()
		);

		my $str=join("#", @data)."\n";
		print $handle $str;
	}

	close $handle;
}

#This one will get the record by id. If the record exists, we want to remove
#it from the storage too and save the backend file... In the face of an 
#undefined record, we will return a false value.
sub delete_record {

	my $id=shift;
	my $it=0;
	my @results=find_records("id", $id, $it);
	if(!scalar @results) {
		return 0;
	}

	#Remove the contact...
	splice @_contacts, $it, 1;

	#...and dump to file :D.
	save_records_to_file($_filename);
	return 1;
}

#This subroutine will get the id, a field ("name" or "address") and a value
#as parameters. If a record with the given id exists, it willchange the 
#requested value and update the storage file. The subroutine will return a 
#false value if the record is not defined.
sub update_record {# (updates name or address)
	
	my ($id, $field, $value)=@_;

	my $methodname;
	if($field eq "name" or $field eq "address") {
		#Same technique we saw before: compose a method name as a string....
		$methodname="set_".$field;
	}
	else {
		print "Unknown field '$field' to 'update_record', exiting\n";
		die;
	}

	my @records=find_records("id", $id);
	return 0 if !scalar @records;

	#Update values and dump...
	$records[0]->$methodname($value);
	save_records_to_file($_filename);
	return 1;
}

#Another easy routine, it will get name, address and a single phone to create
#a record, add it to the records array and to the backend storage. The id
#will be automatically set by the underlying implementation of 
#"contact_revisited", so that's one less thing to worry about.
sub create_record {

	my ($name, $address, $phone)=@_;
	push @_contacts, contact_revisited->new($name, $phone, $address);
	save_records_to_file($_filename);
}

#Again, an easy routine if we make use of the contact_revisited features. 
#It will get the id and the phone number. Will return a false value if no 
#such contact exists or will update the contact and the backend file. The
#rest of the implementation depends on "contact_revisited".
sub add_phone_to_record {

	my ($id, $new_phone)=@_;

	my @records=find_records("id", $id);
	return 0 if !scalar @records;

	$records[0]->add_number($new_phone);
	save_records_to_file($_filename);
	return 1;
}

#Similar to the one above. This time we make sure we only save the records
#to the file if we actually removed a phone (using the contact_revisited
#internal implementation).
sub delete_phone_from_record {
	
	my ($id, $phone)=@_;

	my @records=find_records("id", $id);
	return 0 if !scalar @records;

	if($records[0]->remove_number($phone)) {
		save_records_to_file($_filename);
	}

	#We may think about returning another value to indicate that the phone
	#does not exist, but for the purposes of this example, all is ok.
	return 1;
}

#Return a true value from a module, always.
1;
