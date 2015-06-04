#!/usr/bin/perl -w
# Feed some random, English-like text into the search interface, see if that crashes!
use strict;
use WWW::Mechanize;
use Test::More; 
use Storable;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"}; 
my $mech = WWW::Mechanize->new();  				
my $testCount=50;

# setup
my $realm = "test";                                     # use the test realm by default
$realm = $ENV{"REALM"}  if defined $ENV{"REALM"};       # but load it from the environment variable, if it was specified
my $host="search-test.library.ualberta.ca";             # use the Test environment by default
# config.txt contains a serialized hash-of-hashes, configuration file for this set of tests, integrated with Jenkins parameters
my $lookup = retrieve 'config.txt';                   # get a static data structure from a file
$host = $lookup->{$realm}{'appserver'} if defined $lookup->{$realm}{'appserver'};
$DEBUG && print "We're in $realm, so I'll be using $host\n";

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
