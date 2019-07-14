#!/usr/bin/perl
use strict;
use warnings;

my $NL="\n";

#Hashes are maps... just as scalars are prefixed with $ and arrays with @, scalars are prefixed
#by %...
my %map=qw(one first two second three third);
print(%map, $NL);

#There are other ways of defining hashes... Notice that unlike in other languages, we use parentheses
#to enclose a hash...
my %hash=(one => "first", two => "second", three => "third");
print(%hash, $NL);

#Hashes are retrieved by key order, which might be a surprise for javascript coders.
my %hash_order=("z" => "a last value", "g" => "a middle value", "a" => "first");
print(%hash_order, $NL);

#Hash keys and values can be of mixed type... But must be scalar. References will fix this later, of course.
my %mixed=(1 => "one", "two" => 2, "three" => 3);
print(%mixed, $NL);

#Adding values to a hash is a regular assignment operation... Notice we use the scalar symbol,
#because we are assigning scalars.
#As for the keys, in arrays we use straight brackets, in maps we use the curly ones.
my %mutable_map=();
$mutable_map{"hello"}="World";
$mutable_map{"good"}="Morning";

#Retrieval is the same, retrieving scalars...
print($mutable_map{"hello"}, $NL, $mutable_map{"good"}, $NL);

#Reassinging keys is the same as assigning them...
$mutable_map{"good"}="language";
print($mutable_map{"hello"}, $NL, $mutable_map{"good"}, $NL);

#And removing keys is a matter of using "delete".
delete $mutable_map{"good"};
print(%mutable_map, $NL);

#Finally we can use for/foreach to iterate hash data... We can use for without declaring a 
#holder for our data, in which case we use $_. This iterates all keys an values...
my %iterate_me=("aaaa" => 1, "aabb" => 2, "zzzz" => 3, "bbbb" => 4, "data" => 5);
for(%iterate_me) {
	print($_, $NL);
}

#We can declare a variable too, with the same results, rather useless...
for my $item (%iterate_me) {
	print($item, $NL);
} 

#Or we can use "keys", which makes way more sense... Notice how the key ordering is
#all freaky...
for my $key (keys(%iterate_me)) {
	print($key, " is ", $iterate_me{$key}, $NL);
}

