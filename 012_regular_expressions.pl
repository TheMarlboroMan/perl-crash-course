#!/usr/bin/perl

#By now you should be used to add this at the beginning of each and every 
#script. You really want the extra safety that these provides. In case you 
#really loathe warnings, try to see them not as something that does not allow
#to run your code, but as the language itself trying to tell you that you are
#making no sense at all!. Correcting your warnings will, in time, provide with
#a better understanding of the language.
use strict;
use warnings;

#As for regular expressions (or regexes, singular "regex"), these are directly 
#built into the language and are a very vast topic. Let us start by covering the
#basics. A regular expression is a string used to see if a scalar value 
#"matches" such a string (by, for example, containing part of it).
#The simplest example is contained in this subroutine (let's get into the 
#habit of not polluting the global scope...)

sub example_one {

	my $will_match="This is really a string";
	my $will_not_match="This is NOT a string";
	#We will be looking for the string "really" in the two scalars above...
	my $regex="really";

	#Two things of note: first, the =~ operator, called the "binding" operator,
	#let's think about it as "matches". The whole expression will return a true
	#value if a match is found, and a false value if not.
	#Second, the / syntax: regular expressions must be between delimiters. The
	#default ones are slashes.

	print "Example 1:\n";
	print $will_match, " matches: ", $will_match =~ /$regex/, "\n";
	#Oh, one more thing, see that x2 at the end? That's the multiplication 
	#operator for a string. It will output two new lines at the end!.
	print $will_not_match, " matches: ", $will_not_match =~ /$regex/, "\n"x2;
}

#Another way of writing the very same thing would be not to store the regex 
#string in a scalar...
sub example_two {

	my $will_match="I really want to match";
	my $will_not_match="I prefer not to match";

	print "Example 2:\n";
	print $will_match, " matches: ", $will_match =~ /really/, "\n";
	print $will_not_match, " matches: ", $will_not_match =~ /really/, "\n"x2;
}

#There is also the negation of the binding operator, which can be read as 
#"not matches" and is written !~
sub example_three {

	my $will_match="I do not match, thus a true value will be returned.";
	my $will_not_match="I match, thus a false value will be returned";

	print "Example 3:\n";
	print $will_match, " matches: ", $will_match !~ /false/, "\n";
	print $will_not_match, " matches: ", $will_not_match !~ /false/, "\n"x2;
}

#How about case sensitivity? Let us repeat example one, but will all uppercase
#subjects...
sub example_four {

	my $will_match=uc "This is really a string";
	my $will_not_match=uc "This is NOT a string";

	#The key is in that little "i" at the end of the delimiters. It means 
	#insensitive...
	print "Example 4:\n";
	print $will_match, " matches: ", $will_match =~ /really/i, "\n";
	print $will_not_match, " matches: ", $will_not_match =~ /really/i, "\n"x2;
}

#So far we are getting boolean results from our regular expressions, but there's
#a lot more we can do. In this example, we will use character classes and 
#matching groups to extract numbers and characters from a string...
sub example_five {

	#On a sidenote, we have used but not talked about "join": it will convert
	#a list/array into a scalar by getting its contents out separated by the
	#first argument, thus the following syntax is just a stupid way of declaring
	#a string...
	my $subject=join "", qw(Will 911 extract 822 data 733 here);

	#Okay... [a-z] means "any alphabetic character from a to z", \d means 
	#"any numeric" character (same as [0-9]), + means "one or more of", a number 
	#between brackets means exactly this amount of" and the parentheses serve 
	#to store the values that match, thus this...
	$subject=~/[A-Za-z]{4}(\d+)[a-z]{7}(\d+)[a-z]{4}(\d+)/;

	#means... "match a word of 4 characters, upper or lowecase", then match a 
	#store one or more digits, then match a word of 7 characters, then match and 
	#store one or more digits, then match another 4 character word and match 
	# and store one or more digits.

	#All the "store" data is stored in the magic scalars $1, $2, $3...
	print "Matched ", join(", ", ($1, $2, $3) ), "\n";

	#Of course, all that could be abbreviated by using a few variables and the
	#+ sign...
	my $word="[A-Za-z]+";
	my $number="\\d+";
	my @matches=$subject=~/$word($number)$word($number)$word($number)/;
	print "Matched ", join(", ", ($1, $2, $3) ), "\n"x2;

	#Just so you know, stuff like \d or [a-z] are called "character classes"
	#and stuff between parentheses are "capture groups".
}

#Using magic variables such as $1 or $2 can be scary in certain contexts.
#Consider this alternative...

sub example_six {

	#The same subject as before...
	my $subject="Will911extract822data733here";

	#Notice the modifier "g", for "global"... It tells Perl to keep finding 
	#matches. In this case, it asks to find as many consecutive digits as
	#possible... We store the result of the binding operator in the array
	#@matches

	my @matches=$subject =~ /(\d+)/g;

	#Which in array context contains the results, and in scalar context, the
	#amount of results.
	print "Example six: \n", join (", ", @matches), " => ", scalar @matches, "\n";
}

#Finally, for sed maniacs, there is built-in replacement in Perl regexes.
#Syntax is a lot like in sed:

sub example_seven {

	#A bit of spice: extract from the parameters the thing we will put in 
	#place of any digits...
	my $new_digit=shift;

	#Space separated subject...
	my $subject=join " ", qw(Will 911 extract 822 data 733 here 888 and 999 so 332 on 111);


	#Now, this looks like sed, doesn't it? The binding operator will return 
	#the number of substitutions... $subject will change to reflect this!
	my $copy=$subject;
	my $substitutions=$subject =~ s/(\d+)/$new_digit/g;

	print "Every digit in '$copy' has been substituted by $new_digit for a total of $substitutions changes : $subject", "\n"x2;

	#There are non-destructive idioms that preserve the original string, like...
	(my $new_copy = $copy) =~ s/(\d+)/$new_digit/g;
	print "Every digit in '$copy' has been substituted by $new_digit for a total of $substitutions changes : $new_copy", "\n"x2;

	#However, there is also the r modifier:
	my $second_copy = $copy =~ s/(\d+)/$new_digit/gr;
	print "Every digit in '$copy' has been substituted by $new_digit for a total of $substitutions changes : $second_copy", "\n"x2;
}

#And that's it: here are the function calls:

example_one();
example_two();
example_three();
example_four();
example_five();
example_six();
example_seven(123);

#There is MUCH, MUCH more abour regular expressions... If you really want to 
#know more perhaps you should read some Perl specialized material.
