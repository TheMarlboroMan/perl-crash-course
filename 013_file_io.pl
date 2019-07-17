#!/usr/bin/perl
use strict;
use warnings;

my $NL="\n";

#Input and output in perl is remarkable simple... We already know the basic
#print operation and how to get data from the standard input...

sub basic_input_and_output {

	print "This is the print operation", $NL, ">>";

	my $input=<STDIN>;
	chomp $input;
	print "You just wrote '$input'", $NL;
}

#The next thing we will learn is how to open a file to read from it. This
#subroutine will read the parameters to get a filename and will try to open
#the file. If the file can be opened, it will return a filehandle. It not,
#it will return "undef", which is Perl for "undefined value".
sub open_file_to_read {

	my $filename=shift;

	#This will be the file handler variable: just a regular scalar...
	my $filehandle=undef;

	#Open will open the file, < indicates "read mode"...
	my $result=open($filehandle, "<", $filename);

	#If the file cannot be opened, "open" will return undef, thus...
	return undef if !defined $result;

	#If everything worked, we can return the handle...
	return $filehandle;
}

#This subroutine will get a file handle (not a filename!!) from the parameters
#and will read its contents, line by line, putting them out through the STDIN.
#It will also try to detect if the handle is invalid according to the contract
#in "open_file_to_read" (that is, return "undef" when the file cannot be 
#opened).
sub read_and_print_full_file {

	#Most of these scripts gloss over the most basic validation, but be sure
	#to get into the habit of validating your input.
	my $handle=shift;
	if(!defined $handle) {
		print "Invalid handle passed to read_and_print_full_file...", $NL;
		return;
	}

	#Reading is just a matter of using the <> operator... just like <STDIN>
	#grabs data from the standard input, <handle> will grab a line from our
	#file handler.

	#We may read it into some variable...
	my $line=<$handle>;
	print $line;

	#Or we might use a loop and the automatic variable $_...
	while(<$handle>) {
		print $_;
	}

	#Hands down, this might be the easiest file input ever.
}

#This subroutine will close the file associated with the handle (not filename)
#passed. As before, it will try to check if the handle is defined... Now it 
#may be a good time to say that there are better ways of doing this kind of
#checking (starting with prototypes and ending somewhere along the line), but
#we will deal with these later.
sub close_file {

	my $handle=shift;
	if(!defined $handle) {
		return 0;
	}

	#Closing file handles is as easy as this... As in other languages, handles 
	#will be closed automatically but it is just good sense to close them 
	#ourselves.

	close $handle;
	return 1;
}

#This is just lke "open_file_to_read", but we change the mode to "write". This
#mode will create the file for us if it doesn't exist. It will also truncate
#any contents the file may have if it exists...
sub open_file_to_write {

	my $filename=shift;
	my $result=open(my $filehandle, ">", $filename);
	return undef if !defined $result;
	return $filehandle;
}

#This is like "open_file_to_write", but if the file exists, it will not truncate
#its contents, but keep writing at the end.
sub open_file_to_append {

	my $filename=shift;
	my $result=open(my $filehandle, ">>", $filename);
	return undef if !defined $result;
	return $filehandle;
}

#A simple loop to get data from the standard input and return it as an array.
sub get_data_from_stdin {

	my $type=shift;
	my @result;

	while(1) {
		print "Enter a line $type, 'end' to stop >>";
		my $line=<STDIN>;
		chomp $line;
		last if $line eq "end";
		push @result, $line;
	}

	return @result;
}

#This subroutine will get a filehandle and an array of strings, and will put
#each of these strings to the file in a new line. Remember that arrays must be
#passed by reference, hence $lines and @$lines.
sub write_to_file {

	my ($filehandle, $lines)=@_;
	
	#Check the handle...
	return 0 if !defined $filehandle;

	#Iterate all lines...
	for my $line(@$lines) {
		#Writing to a line is just printing to it... So easy :).
		print $filehandle $line.$NL;
	}

	return 1;
}

#This will remove the given file... Want to know how it works? Try 
#to do "perldoc -f unlink" in your command line. Yes. You have the Perl 
#documentation wherever you go.
sub remove_file {

	#So concise :)...
	unlink shift;
}

basic_input_and_output();

#This file does not exist... 
my $bad_handle=open_file_to_read("resources/bad_file.txt");
read_and_print_full_file($bad_handle);
close_file($bad_handle);

my $good_handle=open_file_to_read("resources/input_file.txt");
#Just so we know, printing a valid file handle will say "GLOB" plus the memory address
read_and_print_full_file($good_handle);
close_file($good_handle);

#Write to a file...
my $write_handle=open_file_to_write("resources/write_here.txt");
my @write_data=get_data_from_stdin("to write");
write_to_file($write_handle, \@write_data);
close_file($write_handle);

#Append to the same file...
my $append_handle=open_file_to_append("resources/write_here.txt");
@write_data=get_data_from_stdin("to append");
write_to_file($append_handle, \@write_data);
close_file($append_handle);

#Print out the contents, they must match what we entered.
my $check_handle=open_file_to_read("resources/write_here.txt");
read_and_print_full_file($check_handle);
close_file($check_handle);

#And remove the file.
remove_file("resources/write_here.txt");

#And that's it, basic file input/output will enable to start being productive
#with Perl. There's lot's we have yet to see (command line arguments, the naked
#<> operator...) but let's try to write something in the next script.
