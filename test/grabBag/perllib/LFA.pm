# Author:	Neil MacGregor
# Date: 	Aug 1, 2012
# Version: 	This file is revision-controlled, see https://code.library.ualberta.ca/hg/era-test
# Purpose:	This Log File Adapter is designed to be hooked into a textual, appending-style log file.
# 		You tell it where to start processing, and then later you ask it whether it saw any bad things.
# Note: 	If you're using this, it like means you can multiplex & run the tests concurrently - if two
# 		tests were watching one log file simultaneously, and one causes a new line to be written to
# 		the log, BOTH tests would see the new entry.  That would be bad!
# Note: 	This is desgned to be an abstract class! You never instantiate an LFA object. Write new 
# 		code to make an LFA for a specific log file, see Catalina.pm

package LFA;  # Log File Adapter
use strict;
use WWW::Mechanize;
use Fcntl qw(SEEK_END SEEK_CUR);

# Constructor for this class
sub new {
my $this = shift;
my $class = ref ($this) || $this;
my $self = {};

# The first parameter must be the name of a valid file
my $fileName = shift; 
die "You forgot to supply new() with a parameter!" unless defined $fileName;
my $fh; 
open ($self->{"filehandle"}, "<$fileName") || die "Failed to open $fileName: $!";

# Use these as a template, when you inherit from LFA!
# hashref-within-hashref - descrptions of the line counters you'll use in analyzing the log files
#$self->{"description"}->{"Total"}		="Total number of lines processed";

# initialize the count to zero
# foreach my $key (keys %{$self->{"description"}}) { # dereference hashref-within-hashref
# 	$self->{"counter"}->{$key} = 0;
# 	}
#
# by default, skip forward to the end of the file
#$self->goToEnd;

bless $self, $class;
return $self;
}

#  this seeks forward to the end of the file
sub goToEnd {
my $self=shift;

my $fh=$self->{"filehandle"};   	# get the FH from the object
my $code = seek($fh, 0, SEEK_END); 	# go to the end of the file
die "Unable to seek to the end of the file " unless $code;
return $self;
}

#  this seeks back to the beginning of the file
sub goToStart {
my $self=shift;

my $fh=$self->{"filehandle"};   	# get the FH from the object
my $code = seek($fh, 0, 0); 	# go to the beginning of the file
die "Unable to seek to the beginning of the file " unless $code;
return $self;
}

# This reads anything new, since you *last* called 
sub analyzeLog {
my $self=shift;

# attempt to read new lines from the file
my $line; 
while ($line = $self->next) {
	print $line;   # printing as we go
}
return $self;
}


# attempt to read another line from the file, at the current position
sub next {
my $self=shift;

my $fh = $self->{"filehandle"};
my $code = seek($fh,0,SEEK_CUR); # reset our position in the file, maybe somebody else wrote to it 
die "Unable to seek back to the current position" unless $code;
return  <$fh>;  # return one line read from the current position in the file!
}
1; 
