#By now you should be used to these...
use strict;
use warnings;
#...and these.
package input_manager_exercise;

#This package defines a subroutine that gets input from the stdin as an array in
#a way that the first two words are two separate elements and anything else
#is the same, third element.

#The subroutine that returns the input. The first parameter is a prompt, by 
#default ">";
sub get {

	#New idiom: // evaluates the left, if the left is "undef", then returns
	#the right, else the left.
	my $prompt=shift // ">";
	
	#Prompt and get the input....
	print $prompt;
	my $data=<STDIN>;
	chomp $data;

	#Split the input by spaces...
	my @result=split " ", $data;

	#Early return if no more than 3.items were given...
	return @result unless scalar @result > 3;

	#Now, from right to left, remove everything from the 2nd index upwards, 
	#turn it into a single scalar by joining with spaces and push it into the
	#result, effectively resulting in 3 items: first, second and the last. Even
	#if we use a single word as input, this will not explode in our faces.
	push @result, (join " ", splice (@result, 2));
	return @result;
}

#You should be also familiar with this.
1;
