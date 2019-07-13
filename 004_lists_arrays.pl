#!/usr/bin/perl
use strict;
use warnings;

#Lists and arrays are related... This is a list: some values in parentheses...
print((1,2,3,4));

#Another list, of mixed types... Also, we can omit the innermost parentheses...
print("\n", "This", " ", "is", " ", "a", " ", "list", " ", 33, "\n"); 

#Of course, we can make lists with variable values...
my $var_1="world";
my $var_2=12;
print("\n", "Hello ", $var_2, " ", $var_1);

$var_1="friends!";
$var_2=22;
print("\n", "Hello ", $var_2, " ", $var_1);

#A fun thing: qw (i guess it stands for "quote word"): creates lists from literals separated by whitespace...
print("\n");
print(qw(Welcome -to -the -fun -world -of -strings));

#Apparently, qw supports any non-alphanumeric delimiters...
print("\n");
print(qw*Welcome (to (the (fun (world (of (strings*);

#Zero-based indexes allows us to access list elements...
print("\n");
print( ("just", "pick", "a", "word", "from", "this", "list")[3]);

#Even better, we can access more than a single element...
#Also, notice the -1: allows picking the nth element from the back!!!
print("\n");
print( ("just", "pick", "a", "word", "from", "this", "list")[0, 2, 3, -1]);

#A favourite feature of mine: ranges. These are used with two dots.
print("\nRange from 1 to 10:");
print( (1..10));
#This, however, does nothing, ranges seem to work only on forward directions...
#print( (10..1));

#Ranges can also be alphanumeric!
print("\nAlphabetic range from a to f:");
print(("a".."f"));

#This maddness is valid too :D.
print("\nAlphabetic range from aa to bb:");
print(("aa".."bb"));

#So, arrays are lists assigned to a variable... the trick here is that arrays are not
#scalars, so instead of the scalar symbol $, we use @ so...
my @numeric_array=(1,2,3,4,5);
print("\nAn array:");
print(@numeric_array, "\n");

#Of course, if we wished to access only one member of the array, that would be an scalar, so...
print("\nA scalar element of an array:");
print($numeric_array[2], "\n");

#Slicing can be done extracting portions of arrays...
my @a_slice=@numeric_array[2,3];
print("\nA slice: ", @a_slice, "\n");

#Freaky thing... arrays and scalars can share names and be different things...
my $a_slice="I love cheese";
print("This is the array @a_slice and this is the string '$a_slice'\n");

#We can also "cast" an array to scalar and get its size...
print("The array has ", scalar @numeric_array, " elements and the slice has ", scalar @a_slice, "\n");

#There is also the freak operator #, which somehow does not start a comment and returns the highest index.
#I am also trying to find the logic of using the $. I guess this is perl's way of saying "I want an scalar if
#i use $, and I want an array if I use @".
print("Largest index of array is ", $#numeric_array,"\n");

#And of course, we have our suite of array operations: pop, push, shift, unshift...
#Starting from the empty list...
my @arr=();

#Push some values...
push(@arr, "Hi", "!");
print("\n", @arr);

#Pop the exclamation point and push some more stuff...
pop(@arr);
push(@arr, " friends,", "have", " ", "fun with perl!");
print("\n", @arr);

#Shift "Hi friends,"... add "Let's all ";
shift(@arr);
shift(@arr);
unshift(@arr, "Let's all", " ");
print("\n", @arr);

#Finally, of course, we can sort arrays. Arrays are sorted in ascending order, but we can 
#use lambdas (expressed as blocks) to specify our stuff... The block must return -1, 0 or
#1 expressing if the first element is lesser, equal or greater than the second.
my @sort_me=(4,5,3,1,2);
my @sorted=sort @sort_me;
my @resorted=sort {return -1*($a <=> $b);} @sort_me;

print("\n", @sort_me, "\n", @sorted, "\n", @resorted, "\n");
 

