#!/usr/bin/perl
use strict;
use warnings;

my $NL="\n";
my $input;

#First off, look, multi line comments!!!
#First off, let us take a look at the easiest way to get input from the user
#in a terminal environment... First we display a prompt, next we tell Perl to
#chomp whatever comes into the standard input (effectively removing the field
#separator, which is, by default, the new line).

print("Enter something: ");
$input=<STDIN>;
chomp $input;
print("You entered '$input'$NL");

#That said, we will use this input technique in the following examples.
#Perl has lots of control flow structures... we already know for, which has the
#foreach "alias". It has the anonymous and explicit forms to name the currently
#iterated element...

for (1,2,3) {
	print("The element is $_", $NL);
}

for my $item (1,2,3) {
	print("The element is $item", $NL);

}

#There is, of course, if, elsif and else...
print("Enter Y/N: ");
$input=<STDIN>;
chomp $input;
if($input eq "Y") {
	print("You said yes!$NL");
}
elsif($input eq "N") {
	print("You said no!$NL");
}
else {
	print("You said something else!$NL");
}

#But we also have this freaky, english like syntax...
print("Enter Y: ");
$input=<STDIN>;
chomp $input;
#print a message if the condition is not met.
print("You did not enter 'Y'$NL") if($input ne "Y");

#In the same way we have "if", we also have "unless", which gives Perl a 
#definite English-like structure... This one is a bit weird to understand at
#first, but we can just read "if not".
print("Enter something: ");
$input=<STDIN>;
chomp $input;

#Read with me "if not input has length"...
unless(length($input)) {
	print("Your input has no length$NL");
}
else {
	print("You input has length$NL");
}

#We also have while...
my $run=1;
while($run) {
	print("Enter 'exit' to exit this loop: ");
	$input=<STDIN>;
	chomp $input;
	$run=!($input eq "exit");
	unless(!$run) {
		print("You must write 'exit' to exit!$NL");
	}
}
print("You exited the loop...$NL");

#and .. do-while...
$run=1;
do {
	print("Enter 'bye' to exit this other loop: ");
	$input=<STDIN>;
	chomp $input;
	$run=!($input eq "bye");
	unless(!$run) {
		print("You must write 'bye' to exit!$NL");
	}
}while($run);

#Similar to while, again, with a very distinct English flavour, we have "until".
$run=0;
until($run==1) {
	print("This will loop until you enter 'enough': ");
	$input=<STDIN>;
	chomp($input);
	$run=$input eq "enough";
	unless($run) {
		print("You must write 'enough' to exit!$NL");
	}
}

#We also have do-until...
do {
	print("This will loop until you enter 'quit': ");
	$input=<STDIN>;
	chomp($input);
	$run=$input eq "quit";
	unless($run) {
		print("You must write 'quit' to exit!$NL");
	}
}until($run==1);

#"given" works like a switch case thing...  "break" is implicit, "continue"
#means an absence of break so... This feature is not supported by default, so
#we must use it first...
use feature "switch";

print("Enter a number: ");
$input=<STDIN>;
chomp $input;

#Let us bring some utils...
use Scalar::Util qw(looks_like_number);

given($input){
	when(not looks_like_number($input)) {
		print("That was not a number...$NL");
	}

	when($input >= 0 && $input <=10) {
		print("Between 0 and 10$NL");
		continue;
	}
	when($input == 0) {
		print("Is zero$NL");
	}
	when($input == 1) {
		print("Is 1$NL");
	}
	default{
		print("Something else, not zero or 1$NL");
	}
}

#Of course, english-like syntax is supported here too. There is a certain 
#elegance to this syntax and use of unless...
$run=1;
do {
	print("Enter a number larger than 20:");
	$input=<STDIN>;
	chomp $input;
	
	given($input) {
		$run=-1 when 21;
		$run=-2 when 22;
		$run=-3 when $input>22;
		default {$run=1;}
	}

	print("Exiting with status [$run]...$NL") unless $run > 0;

}while($run > 0);

#All that is left for us to review is "next", which looks like "continue" in
#the C family of languages, and "last", which means break. The catch is that
#they are not "commands", but rather they want expressions. Also, they do
#not seem to work on do-while loops so...

while(1) {
	print("Enter an empty string: ");
	$input=<STDIN>;
	chomp $input;

	last if(!length($input));
	
	print("You must enter an empty string to exit$NL");
	next if(length($input));
	print("This will never be printed");
};

#And finally, look, multi-line comments!!!
=begin comment
This is a comment
whithout the # thing...
=end comment
=cut

print("Exiting$NL");
