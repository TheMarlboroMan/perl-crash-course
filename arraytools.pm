use strict;
use warnings;
package arraytools;

#This subroutine gets an array and a numeric search term and will return
#the index of the array that matches the numeric term or -1. This, of course,
#would be much more powerful if we just passed a block to test to the function,
#but this is quick and easy.
sub first_index_of {

	my $arr=$_[0];
	my $search=$_[1];

	my $index=0;
	for my $curr (@$arr) {
		return $index if $curr==$search;
		++$index;
	}
	return -1;
}

#As always, a true value must be returned from a module.
1;
