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
# get_records

#These methods will be the "public" interface for this class. The private 
#interface will be any other helper methods we may come accross.

#First off, we need the contact_revisited module!
use contact_revisited;

#And next we need to define our storage and other things... We could use a few
#global variables for this module, but instead of that, we will build a class.
#This way we might have several instances of these record managers, each 
#with their own data, if need be.

sub new {

	my ($class, $filename)=@_;

	#storage will be the array where we store stuff, filename will be the
	#filename we read/write to.

	#Note on syntax: this is way more real than previous examples: the outer
	#{} creates a reference for a hash, the inner [] does the same for an array.
	my $data={storage => [], filename => $filename};
	bless $data, $class;

	_read_records($data);

	return $data;
}

#We can now begin to build subroutines. This one encapsulates reading data from 
#the given file or the default filename. Notice how this is "private", beginning
#with an underscore. This is so because we want this class to be ready at 
#construction time, so we call this method from the constructor.
sub _read_records {

	my $this=shift;

	if(!length $this->{filename}) {
		print "Filename must be set, exiting\n";
		die;
	}

	#Try to load from the good file or the default file...
	if(!$this->_read_records_from_file($this->{filename})) {

		print "Could not find $this->{filename}, loading defaults...\n";
		if(!$this->_read_records_from_file("resources/sample_records.txt")) {
			print "Could not read records from default file. Exiting\n";
			die; #Die will stop our program.
		}

		print "Saving defaults to real file...\n";
		$this->save_records_to_file($this->{filename});
	}


	#Actually, it might be bad that our routines have these sort of secondary
	#effects, such as printing to the stdout... Consider that your real 
	#subroutines should do one thing and one thing only!.

	print scalar @{$this->{storage}}, " records loaded...\n";
}

#This is the the private subroutine to read records from the file.  It will take 
#the filename as a parameter and fill up @storage with the data. If we cannot 
#open the file, we will return a false value. 
sub _read_records_from_file {

	my ($this, $filename)=@_;

	return 0 unless open(my $handle, "<", $filename);

	#Just because we can, let us empty the storage, in case we want to call this
	#suboutine more than once.
	$this->{storage}=();
	while(<$handle>) {

		 #Remove the newline and get parameters from the file...
		chomp $_;
		my ($id, $name, $address, $phones)=split '#', $_;

		#Do we have a repeated id?
		if(scalar $this->find_records("id", $id)) {
			close $handle;
			print "Found repeated id $id, exiting\n";
			die;
		}


		
		#Create the contact with no phones...
		my $record=contact_revisited->new($name, undef, $address, $id);

		#As long as there are phones left, add them...
		for(split ',', $phones) {
			$record->add_number($_); #This is another $_ than the one above...
		}

		#Add the contact to the records...
		push @{$this->{storage}}, $record;
	}

	close $handle;
	return 1;
}

#This subroutine will take two values: the first is a string indicating the
#"field" we are searching, and the second indicates the value we search. The
#subroutine will return undef if cannot  anything, or an array of results.
#There is a third parameter, it. It will be passed along when we want to get
#the index of the result.
sub find_records {

	my $this=shift;

	#Make copies of the arguments $it is a copy of a possible @_[2], so any
	#changes to $it mean nothing. We fix that it in the end.
	my ($field, $value, $it)=@_;

	$it=0 if defined $it;

	my @results;

	#Let us validate the data...
	my @possible_values=("id", "name", "address", "numbers");

	#Grep performs a regular expression... ^ and $ are "beginning of a line" and
	#"end of the line", thus we want to know if $field is any of 
	#@possible_values. The important takeaway here is that you can do grep on 
	#arrays.
	if(! grep(/^$field$/, @possible_values)) {
		print "Unknown field '$field' to 'find_records', exiting\n";
		die();
	}

	#This is ugly, but we can use strings to compose subroutines names and 
	#call them later...
	my $methodname="get_".$field;

	for my $current (@{$this->{storage}}) {

		if($field eq "id") {
			if($current->$methodname() == $value) {
				push @results, $current;
				last; #No need to keep going, we have only 1 value per id.
			}
		}
		elsif($field eq "name" or $field eq "address") {

			#A bit of regex magic... Notice the "insensitive" tag...
			if($current->$methodname() =~ /$value/i) {
				push @results, $current;
			}
		}
		elsif($field eq "numbers") {
			if(grep(/$value/, $current->$methodname())) {
				push @results, $current;
			}
		}

		++$it if defined $it;
	}


	#Perls parameters are passed by reference, so the caller can get 
	#the index of the result by checking their third parameter.
	$_[2]=$it if defined $it;

	return @results;
}

#This one is easy too... It will get the filename as a parameter and dump the
#records according to the format specified in the exercise. In case of failure
#to write, the program will exit. Considering the use we are doing here, might
#as well be private... Still, for the record, think, does it make any sense
#that any time we make a change we open our file, write all our data and then
#close it?.
sub save_records_to_file {

	my $this=shift;
	my $filename=shift;
	my $handle;
	if(!open($handle, ">", $filename)) {
		print "Could not save to $filename... exiting\n";
		die;
	}

	for(@{$this->{storage}}) {
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

	my $this=shift;
	my $id=shift;
	my $it=0;
	my @results=$this->find_records("id", $id, $it);
	if(!scalar @results) {
		return 0;
	}

	#Remove the contact...
	splice @{$this->{storage}}, $it, 1;

	#...and dump to file :D.
	$this->save_records_to_file($this->{filename});
	return 1;
}

#This subroutine will get the id, a field ("name" or "address") and a value
#as parameters. If a record with the given id exists, it willchange the 
#requested value and update the storage file. The subroutine will return a 
#false value if the record is not defined.
sub update_record {
	
	my ($this, $id, $field, $value)=@_;

	my $methodname;
	if($field eq "name" or $field eq "address") {
		#Same technique we saw before: compose a method name as a string....
		$methodname="set_".$field;
	}
	else {
		print "Unknown field '$field' to 'update_record', exiting\n";
		die;
	}

	my @records=$this->find_records("id", $id);
	return 0 if !scalar @records;

	#Update values and dump...
	$records[0]->$methodname($value);
	$this->save_records_to_file($this->{filename});
	return 1;
}

#Another easy routine, it will get name, address and a single phone to create
#a record, add it to the records array and to the backend storage. The id
#will be automatically set by the underlying implementation of 
#"contact_revisited", so that's one less thing to worry about.
sub create_record {

	my ($this, $name, $address, $phone)=@_;
	push @{$this->{storage}}, contact_revisited->new($name, $phone, $address);
	$this->save_records_to_file($this->{filename});
}

#Again, an easy routine if we make use of the contact_revisited features. 
#It will get the id and the phone number. Will return a false value if no 
#such contact exists or will update the contact and the backend file. The
#rest of the implementation depends on "contact_revisited".
sub add_phone_to_record {

	my ($this, $id, $new_phone)=@_;

	my @records=$this->find_records("id", $id);
	return 0 if !scalar @records;

	$records[0]->add_number($new_phone);
	$this->save_records_to_file($this->{filename});
	return 1;
}

#Similar to the one above. This time we make sure we only save the records
#to the file if we actually removed a phone (using the contact_revisited
#internal implementation).
sub delete_phone_from_record {
	
	my ($this, $id, $phone)=@_;

	my @records=$this->find_records("id", $id);
	return 0 if !scalar @records;

	if($records[0]->remove_number($phone)) {
		$this->save_records_to_file($this->{filename});
	}

	#We may think about returning another value to indicate that the phone
	#does not exist, but for the purposes of this example, all is ok.
	return 1;
}

#Return the records. Given that @storage is an array of references, any caller
#can change the records. Perl does not enforce strict encapsulation. We might
#do a copy of all records and return it, but that would be overkill. Someone
#said that perl would like you to stay away from internals because you are
#polite, not because it has a shotgun.
sub get_records {

	my $this=shift;
	return @{$this->{storage}};
}

#Return a true value from a module, always.
1;
