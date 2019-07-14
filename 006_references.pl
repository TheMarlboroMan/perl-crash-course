#!/usr/bin/perl
use strict;
use warnings;

#References are declared with the \ symbol. Let us first do a bit of a setup
my $NL="\n";
my $value=33;

print($value, $NL);

#Now, assign the reference. Funny thing, a reference is considered a scalar so...
my $reference=\$value;

#Now, to dereference a reference we use double scalar.
$$reference=12;
print($$reference, " and ", $value, $NL);

#We can also use this other syntax.
${$reference}=30;
print($$reference, " and ", $value, $NL);

#Array references work the same, but dereferencing them is funkier. Notice how the reference
#is still a scalar, but a dereferecing looks like "i want to get an array from this scalar".
my @arr=(1,2,3,4);
my $arr_ref=\@arr;
print(@$arr_ref, $NL);

#Accessing individual elements is more perverse still. It reads like "I want to get a scalar 
#from the scalar arr_ref, getting its first element. Confusing, as there is no trace
#that arr_ref is an array except for the curly brackets. There is also the syntax @$arr_ref->[0],
#but seems to be deprecated.
print("Dereferencing element 0: ", $$arr_ref[0], $NL);

#Of course, we can manipulate the reference...
push(@$arr_ref, 5);
print("After adding an element to the reference: ", @$arr_ref, $NL);

#Now, references to hashes work the same as references to arrays...
my %hash=("key1" => "value1", "key2" => "value2");
my $hash_ref=\%hash;
print(%$hash_ref, $NL);

#Adding new keys... Notice the extra amount of hate, but with lots of sense after all: "the scalar pointed
#at by the scalar hash_ref on the key "key3" shall be "value3". We can use [] and {} to distinguish between
#arrays and hashes.
$$hash_ref{"key3"}="value3";
print(%$hash_ref, $NL);

delete $$hash_ref{"key2"};
print(%$hash_ref, $NL);
print(%hash, $NL);

#Finally, using references we can finally create complex arrays and hashes...
my $scalar_number=1;
my $scalar_string="string";
my @array_element=(2,3,4);
my %hash_element=("akey" => "a", "bkey" => "b", "ckey" => "c");

#Scalars are added by "copy", arrays and hashes by reference...
my @complex_array=($scalar_number, $scalar_string, \@array_element, \%hash_element);

#This will print "HASH" and "ARRAY" in place of the corresponding elements, followed by their
#memory addresses..
print(@complex_array, $NL);

#Same as this...
print($complex_array[2], " ", $complex_array[3], $NL);

#...but this is what we want... I wonder if there are more succint syntaxes...
my $ref=$complex_array[2];
print(@$ref, $NL);

$ref=$complex_array[3];
for my $key (keys(%$ref)) {
	print($key, " => ", $$ref{$key}, $NL);
}

#Finally, as for hashes and references, it is similar... Similarly confusing until one achieves
#perl monkhood, I guess...
my %complex_hash=(
	"k1" => 1, 
	"k2" => $scalar_string,
	"k3" => \@array_element,
	"k4" => \%hash_element
);

print(%complex_hash, $NL); #Will print out ARRAY and HASH again...

print($complex_hash{"k1"}, $NL);
print($complex_hash{"k2"}, $NL);
$ref=$complex_hash{"k3"};
print(@$ref, $NL);
$ref=$complex_hash{"k4"};
for my $key (keys %$ref) {
	print($key, " is ", $$ref{$key}, $NL);
}

#And that's it... for now.
