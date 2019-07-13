#!/usr/bin/perl
use strict;
use warnings;

#Strings can be encoded freely...
my $NL="\n";
my $string="Strings can include UTF-8 stuff such as ñ or á";
print($string.$NL);

#Also, we can use our very own delimiters. The trick here is starting with "q" and then using
#the delimiter...
my $custom_single_quoted=q/"There will be no interpolation of $string" today and 'an abundance of quotes"'/;
print($custom_single_quoted.$NL);

#We can actually use non-alphabetic characters as delimiters...
my $other_custom_single_quoted=q*This would work '$string"' too*;
print($other_custom_single_quoted.$NL);

#As for something that works like double quotes... we use double q, and a single delimiter...
my $custom_double_quoted=qq=There will be interpolation of '"$string"' today=;
print($custom_double_quoted.$NL);

#Can we use longer delimiters? No, we can't.
#my $experiment=q**Experiment...**;
#print($experiment);

#Of course, there are loads of string functions... Notice how characters in the upper range such as ñ
#are unnafected by uc, lc and yield bad results with length...
#Notice also how embedded new lines in the string work.
my $short_string="ña";
print("Length is of $short_string is ".length($short_string)."
which in uppercase is '".uc($short_string)."' 
and in lowercase is '".lc($short_string)."'
");

#Other useful string functions are the classic index and rindex... which yield zero based indexes
#and -1 for "not-found". Gotta love this language :).
my $subject="I am learning a language today";

print(index($subject, "I")." as the index of I".$NL);
print(index($subject, "z")." as the index of z".$NL);
print(rindex($subject, "a")." as the rightmost index of a".$NL);

#Other classics, substr, which also doubles as replacement...
print(substr($subject, 0, 1)." as the 0-1 substr".$NL);

#Interestingly, replacement works "in place"... $replaced will be "I am", 
#part of the old value of $subject, because $subject will change. 
my $replaced=substr($subject, 0, 4, "You are");
print($replaced.$NL.$subject.$NL);
