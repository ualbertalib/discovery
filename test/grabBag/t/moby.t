#!/usr/bin/perl -w
# Feed some random, English-like text into the search interface, see if that crashes!
use strict;
use WWW::Mechanize;
use Test::More; 

my $mech = WWW::Mechanize->new();  				
my $testCount=50;
#my $url="https://tottenham.library.ualberta.ca/users/sign_in";		# The HAproxy interface: not until you ditch the self-signed cert.  Requirements: "yum install perl-Crypt-SSLeay perl-LWP-Protocol-https" 
my $host="search-test.library.ualberta.ca";
$host = $ENV{"TARGETHOSTNAME"}  if defined $ENV{"TARGETHOSTNAME"};
my $url="https://$host";  


$mech->get( $url );    		# Visit the sign_in page
my $searchString;

#  Retrieve the text of Moby Dick from gutenberg.org, but only once, eh?
my $bigWhale = "/var/tmp/mobyDick.txt";
`wget -O $bigWhale http://www.gutenberg.org/ebooks/2701.txt.utf-8` unless -e $bigWhale;

my $a ; $searchString = undef;
open (RANDWORDS, "-|", 'sort -R /var/tmp/mobyDick.txt  | awk -F" " \'{ print $1, $2, $3;}\'') || die "Can't get random words: $!";   # hardcoded filename, sorry
for ($a=1; $a< ($testCount+1); $a ++) {
	do  {
		#print "Generating random words...\n";
		$searchString = <RANDWORDS>;
	} until (defined $searchString && length ($searchString) > 5 );
		
	chomp $searchString;
	#$searchString =~ s/[,."';:]//g;  # remove punctuation, because we have a bug with puntuation, and sometimes I want to skip over that bug & search for other problems
	#print "$a. Searching for: $searchString\n";
	eval {$mech->submit_form( fields    => { q => $searchString, },);  };
	ok ($mech->status ==  200, "$host: Search for: $searchString");
	undef $searchString; 
}
close RANDWORDS;	

done_testing $testCount;
