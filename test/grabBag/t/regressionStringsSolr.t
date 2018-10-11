#!/usr/bin/perl -w
# Author: 	Neil MacGregor
# Date: 	May 25, 2015
# Purpose: 	A regression testing suite against the Test instance of Discovery
#		At one time, all of these strings caused "500 Internal Server Error"-style crashes
#		Some were due to the Zero Results bug
#		Some were due to a bug in handling punctuation
#		These were inspired by early revisions of mobyTest.pl, which found these class of errors!
# RevisionCntl: 
# Context: 	
# Ideas for improvement:  This should take a parameter that will allow us to run it against either Test or Prod!
use strict;
use WWW::Mechanize;
use Test::More;
use Storable;
use URI::Escape;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};
# setup
my $realm = "test";                                     # use the test realm by default
$realm = $ENV{"REALM"}  if defined $ENV{"REALM"};       # but load it from the environment variable, if it was specified
my $host="solrcloud-test.library.ualberta.ca:8080";             # use the Test environment by default
# config.txt contains a serialized hash-of-hashes, configuration file for this set of tests, integrated with Jenkins parameters
my $lookup = retrieve 'config.txt';                   # get a static data structure from a file
$host = $lookup->{$realm}{'solr'} if defined $lookup->{$realm}{'solr'};
$DEBUG && print "We're in $realm, so I'll be using $host\n";


my $mech = WWW::Mechanize->new();  				
my $url="http://$host/solr/discovery-test/select?";  
#http://solr-test.library.ualberta.ca:8080/solr/discovery-test_shard2_replica2/select?q=sports%3B+his+slouched&wt=json&indent=true

#$mech->get( $url );    		# Visit the sign_in page
my $searchString;
my @knownBad = ( 	"All the yard-arms",
			"Pusie Hall can",
			"the Guernsey-man to",
			"sports; his slouched",
			"my sire. Leap!",
			"\"Find who?\"",
			"freshets of blood",
			"vibrating his predestinating",
			"domesticated them. Queequeg",
			"sullen paws of",
			"\"Sweet fields beyond",
			"convulsively grasped stout",
			"butts all inquiring",
			"honourable whalemen allowances",
			#"OR anything else fails", 		 # Aug 04, 2015 - Henry notices uppercase AND & OR operators crash the app if they appear first
			#"AND anything else fails",		 # but, it seems these are not quite bugs - it's how the boolean-operator parser works :)
			#"--WHALE song",				# Neat! Anything with "--<word> <word>" fails
			"global",				# Kenton's intriging error releated to the MySQL max-packet-size vs session_id for this ONE query.  Weird.
			"New",					# So, these all might be related -- searches that return a very large number of results? 
			"York",					# 
			"Canada",				# 
			"United",				# 
			"New York",				# 
			"United States",			# 
		);
my $count=0;
my $result; 
foreach $searchString (@knownBad) {
	$searchString = uri_escape $searchString; 
	$DEBUG && print "Trying: $url" . "q=$searchString...\n";
	eval {$result = $mech->get( $url . "q=$searchString" );   };
	ok ($mech->status == 200, "$host: Search for $searchString") ; $count ++;
	ok (defined($result) , "Did we get content?"); $count++;
	if (defined ($result)) {
		unlike  ($result->decoded_content, qr/We are sorry, something has gone wrong/, "Check for masked error") ;   #  Ugh, in Prod, we try to return a pretty error, not a bare 500
		$count ++;
	}
}
done_testing $count;
