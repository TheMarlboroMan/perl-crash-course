#!/usr/bin/perl
use warnings;
use strict;

my $NL="\n";

#Subroutines is what we know as "functions"... I actually prefer the "routine"
#style of naming, to be honest, as it expresses the intent clearly. Anyhow,
#here is a very simple subroutine.

sub prompt {
	#By the way, notice how the global $NL is accesible inside this subroutine...
	print ">>$NL";
}

#And here is how you use it, with an ampersand.
&prompt;

#Or for a more familiar syntax...
prompt();

#A subroutine reference can be taken...
my $ref_to_prompt=\&prompt;

#...and used...
&$ref_to_prompt;
&{$ref_to_prompt};

#Subroutines take arguments, of course... In this case, arguments are stored in
#the local array @_. You might be wondering "what about prototypes?", oh, yes,
#they exist in Perl but they don't do what you think they do. In fact, the
#easiest way to go about subroutine arguments is to assume and understand
#right now that arguments always are in the special array @_. That's the way
#it goes with Perl.
sub prompt_2 {
	my $symbol=$_[0];
	print $symbol,$NL;
}

prompt_2("=>");

#Of course, nobody will ever forbide us from adding more arguments than we need.
#See all these arguments? They will be flattened into an array...
prompt_2(">>", "these", "are", "all", "unused");

#So, perhaps we can do some checks like... remember "scalar"?
sub prompt_3 {
	unless(1==scalar @_) {
		print("prompt_3 must be called with a single argument$NL");
	}
	else {
		print $_[0], $NL;
	}
}

prompt_3("=>", "useless");
prompt_3(">");

#Ok, now, subroutines return by default their last statement...
my $return_value=prompt_3(">>");
print "The return value is ", $return_value, $NL;

#Perhaps this is not what we want so, as useless as this might look, at least
#we are returning an undefined value now...
sub prompt_4 {

	unless(1==scalar @_) {
		print("prompt_3 must be called with a single argument$NL");
	}
	else {
		print $_[0], $NL;
	}

	return undef;
}

#Because return value is now undef, we cannot use it...
$return_value=prompt_4(">>");

#How about a subroutine that actually does something useful?
sub get_input {
	unless(1==scalar @_) {
		print ">>";
	}
	else {
		print $_[0];
	}

	my $input=<STDIN>;
	chomp $input;
	return $input;
}

do {
	$return_value=get_input("Enter 'exit' to stop: ");
}while($return_value ne "exit");

#An interesting example now... The default way of passing a parameter is by
#reference...
sub pass_by_ref {
	$_[0]+=1;
	$_[1]+=1;
	return undef;
}

my ($param1, $param2)=(1, 10);

for(1..10) {
	pass_by_ref($param1, $param2);
}
print "param1 has a value of ", $param1, " and param2 has a value of ", $param2, $NL;

#To pass by copy, we make a lexical copy...
sub pass_by_copy {
	my $copy=$_[0];
	$copy+=1;
	return $copy;
}

$param1=0;
$return_value=pass_by_copy($param1);
print "param1 has a value of ", $param1, " and return_value is ", $return_value, $NL;

#In fact, we'd rather look at this idiom right away: this is the way we usually
#get our arguments in Perl: a single "my" with the list of arguments, extracted
#from @_. This way, we make our copies of the arguments and give them names...
sub argument_idiom {

	my ($arg1, $arg2, $arg3)=@_; #These are silly names, in any case.
	print "arg1=$arg1, arg2=$arg2, arg3=$arg3", $NL;
}
argument_idiom("Three", "Little", "Pigs");

#Passing arrays to routines needs references. Why? Well, remember how Perl
#flattens arrays with other arrays inside? Remember how arguments in Perl are
#always in an array? How do you think these two things play together?. 
#Anyhow, this subroutine will calculate the sum of all values in the array...
sub sum_array {

	my $arr_ref=$_[0];	#This is the reference to the array...

	my $retval=0;
	for my $item (@$arr_ref) { #Substitute the array for its reference and we are done...
		$retval+=$item;
	}

	return $retval;
}

my @arr=(10, 5, 3, 2);
print "The sum of @arr is ", sum_array(\@arr), $NL;

#Returning an array of hash is similar... For example, this will return a hash with
#three keys: min, max and sum...
sub sum_and_more {

	my $arr_ref=$_[0];
	my %retval=('sum' => 0, 'min' => $arr_ref->[0], 'max' => $arr_ref->[0]);

	for my $item (@$arr_ref) {
		$retval{'sum'}+=$item;
		$retval{'min'}=$item if ($item < $retval{'min'});
		$retval{'max'}=$item if ($item > $retval{'max'});
	}

	return %retval;
}

my %result=sum_and_more(\@arr);
print "The sum of @arr is ", 
	$result{'sum'}, 
	" its min value is ", 
	$result{'min'}, 
	" and its max value is ", 
	$result{'max'}, 
	$NL;

#One more thing, nothing stops us from redefining a subroutine and shoot 
#ourselves in the foot, as in:
#sub sum_and_more {
#	print "Bad deal\n";
#}
#sum_and_more(\@arr);
#So let's not do that.

#And that's about it.
