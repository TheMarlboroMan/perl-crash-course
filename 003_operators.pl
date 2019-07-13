#!/usr/bin/perl
use strict;
use warnings;

#One interesting operator we don't know, the "exponent", performs power-of calculations...
print("2 to the 3rd is ".(2**3)." and 8 squared is ".(8**2)."\n");

#Other colorful operator, the spaceship... This returns -1, 0 or 1 if the leftmost operand 
#is lesser than, equal or greater than the rightmost one...
print("2<=>4 equals ".(2<=>4)."\n2<=>2 equals ".(2<=>2)."\n2<=>1 equals ".(2<=>1)."\n");

#And my favourite thing ever: the classic operators we know are applied only on numbers.
#String operators are different, so everything is disambiguated.

my $string_a="String a";
my $string_b="The string b";
my $string_c="The string c";
my $string_aa="String a";

#This is equals... beautiful.
print("a eq aa: ".($string_a eq $string_aa)."\na eq b".($string_a eq $string_b)."\n");

#This is not-equals... which should provide reversed results as the previous stataments.
print("$string_a ne $string_aa: ".($string_a ne $string_aa)."\n$string_a ne $string_b".($string_a ne $string_b)."\n");

#This is comparison... Works like the spaceship, but with strings, if that makes any sense.
print("$string_a cmp $string_b: ".($string_a cmp $string_b)."\n$string_b cmp $string_a: ".($string_b cmp $string_a)."\n$string_a cmp $string_aa: ".($string_a cmp $string_aa)."\n$string_b cmp $string_c:".($string_b cmp $string_c)."\n");

#And the rest of comparison operators for strings...
print("$string_a lt $string_b: ".($string_a lt $string_b)."\n"
	."$string_b gt $string_a: ".($string_b gt $string_a)."\n"
	."$string_a le $string_b: ".($string_a le $string_b)."\n"
	."$string_b ge $string_a: ".($string_b ge $string_a)."\n"
);

#Chomp operator: removes the input record separator which defaults to a newline...
my $to_chomp="this string will be chompeddd\n\n\n";
my $chomped;
do{
	$chomped=chomp($to_chomp);
	print("Chomped $chomped characters, so we are left with '$to_chomp'\n");
}while($chomped);

#The input record separator can be changed... It is called $/.
$/="d";
do{
	$chomped=chomp($to_chomp);
	print("Chomped $chomped characters, so we are left with '$to_chomp'\n");
}while($chomped);
