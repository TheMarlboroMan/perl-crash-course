#!/usr/bin/perl
use strict;
use warnings;

#Comments are like in the bourne shell thing... Put a hashtag and comment away.

#Variables in strict mode (reasonable choice) can be declared with the keywords my and our.
#Variables starting with a dollar are scalars: that is, these are either 
#numbers or strings (so far).
#Strings can either be double or single quoted. We will use double quotes
#through these scripts. Unlike other script languages (I am looking at you,
#Python) double and single quoted strings are different in which double quoted
#strings allow for escape characters.
my $single_quoted_string='hey, an unescaped \bar';
my $nl="\n"; #Comments can also appear 
#The string concatenation operator is a stupid dot...
print("This is one string".$nl.'And this is another'.$nl.$single_quoted_string.$nl);

#This is a block... In strict mode, variables are scoped to their block, which makes sense.
{
	my $number_1=33;
	my $number_2=12.3;
	my $number_3=$number_1+$number_2;
	print($number_3.$nl);
}

#Using strict and block scoping disallows number_3 from being used here.
#print($number_3.$nl);

#Scoping works in a way that just makes sense and shadows same-named variables in higher scopes...
my $shadow="global scope".$nl;

#Also, variable interpolation can be used. Interpolation only works with single quotes.
#So far I see no reason to use single quotes at all...
#Also, interpolation is a scalar thing, non-scalars cannot be interpolated.
print("At global scope, shadow is $shadow");
{
	my $shadow="depth 1 scope".$nl;
	print("Inside one level of scoping, shadow is $shadow");
	{
		my $shadow="depth 2 scope".$nl;
		print("Inside two levels of scoping, shadow is $shadow");
	}
	print("Returning to scope level 1 $shadow");
}
print("Returning to global scope $shadow");

#Now, something crazy about numbers... If we need to use number separators, we can use underscores...
#I guess that makes sense under NASA standards.
my $big_number=123_456_789;
#Oh, also, interpolation can be made to work this way... To interpolate succesive scalars.
print("My big number is ${big_number}${nl}");

#It would be nice to know that we can use binary, octal and hex number formats...
my $binary_number=0b1001; #Should be nine, in binary.
my $octal_number=011; #Should be nine, in octal.
my $hex_number=0x9; #Should be nine, in hexadecimal...
print("Binary: ${binary_number}${nl}Octal: ${octal_number}${nl}Hex: ${hex_number}${nl}");

#Of course, we also have floating-point numbers, but I hate these...
my $floating_point_value=15.33;
my $very_small_value=$floating_point_value / 206.32999999;
print("Floating point: $floating_point_value versus very small $very_small_value${nl}");
