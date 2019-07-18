#!/usr/bin/perl
use strict;
use warnings;

#This script will solve the following exercise:
#Write a program that:
#	- Reads a file "resources/exercise_records.txt" with several records:
#		- One record per line.
#		- Each record represents a "contact_revisited" object, as seen 
#			previously.
#		- Records are structured like id#name#address#comma_separated_phones
#		- If no initial file exists, records must be copied from 
#			resources/sample_records.txt
#	- Records are:
#		- Stored in memory when the script starts.
#		- No records with the same id are allowed!
#	- The script loops accepting user input from stdin like so:
#		- exit : ends the program.
#		- list: must list all contacts with all their data.
#		- delete id: deletes the contact with the given id, saves contacts to 
#			disk. Must check if the contact exists.
#		- new: prompts for name, address and phone. Adds contact and saves data
#			to disk.
#		- add id phone: adds a phone number to the contact with the given id.
#			Must check if the contact exists.
#		- remove id phone: removes a phone number from the contact with the
#			given id. Must check if the contact exists.
#		- setname id newname: must change the name of the contact with the 
#			given id. Must check if the contact exists.
#		- setaddress id newaddress: same as "setname", but with the address.
#		- byname string: searches a contact by name. Prints out the names, 
#			addresses and phone numbers of matches. Must print out matching,
#			names, that is, if "a" is given, all names with "a" or "A" must
#			be returned.
#		- byaddress string: same as "byname", but with addresses.
#		- byphone string: same as "byname", but with phones.
#	- As for implementation details:
#		- Failure in input checking for your subroutines is acceptable at this 
#			point.
#		- Must use the contact_revisited module.
#		- Must separate modules:
#			- A module must keep and interact with the records.
#			- Another must take user input through stdin.
#			- A third must be a that takes the input and generates the output.
#			- The main script does set up.

#First off, given that we must use separate modules, this is a good chance to
#create and test our modules separatedly. This way, all we need to do in the 
#end is glue them together with some Perl. Let's start with the record 
#interaction class. Open the file for the following module and read through:

use record_manager_exercise;

#Let's set the module up... 
my $record_manager=record_manager_exercise->new("resources/014_excercise_records.txt");

#Some might actually prefer to load all modules in the same place, for clarity 
#sake, but for the purposes of this example we load and setup them separatedly.
#Open now the file for the next module and read through:

#Finally, this other module, read the file and notice how it requires a third
#module...
use controller_module_exercise;

#All that is left, is the setup...
my $controller=controller_module_exercise->new($record_manager);
$controller->run();
