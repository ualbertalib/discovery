#!/usr/bin/perl -w
# Author: 	Neil MacGregor
# Date: 	Aug 12, 2015
# Purpose: 	A regression test, validating that we have an appropriate amount of data in the SolrCloud index.
#		On this day, rapidly deployed a release & slammed it all the way into Production, only to discover
#		that the "eBooks and more" bento-pane was permanently empty. ARGH!
#		This was due to a bug, and rapidly fixed, but indicates a lack of testing - it could easily have been
#		spotted in Test, if we had bothered to look.
# RevisionCntl: github, ualbertalib/discovery
# Context: 	the blacklight/discovery project
# Ideas for improvement:  
# 		needs to read *all* the bento-panes
use strict;
use WWW::Mechanize;
use Test::More;
use Storable;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};
# setup
my $realm = "test";                                     # use the test realm by default
$realm = $ENV{"REALM"}  if defined $ENV{"REALM"};       # but load it from the environment variable, if it was specified
my $host="search-test.library.ualberta.ca";             # use the Test environment by default
# config.txt contains a serialized hash-of-hashes, configuration file for this set of tests, integrated with Jenkins parameters
my $lookup = retrieve 'config.txt';                   # get a static data structure from a file
$host = $lookup->{$realm}{'appserver'} if defined $lookup->{$realm}{'appserver'};
$DEBUG && print "We're in $realm, so I'll be using $host\n";


my $mech = WWW::Mechanize->new();  				
my $url="https://$host";  

#$mech->get( $url );    			# Visit the default page

my $searchString="shakespeare"; 	# inspired by Sam's favourite test
my $count=0;
my ($result, $resultsCounter, $content, $match );

my @collections = ( 
	{ 
		name	=>  'symphony',  
		minimum	=>  15000 
	}, 
	{ 
		name	=>  'journals',  
		minimum	=>  10 
	}, 
	{ 
		name	=>  'databases', 
		minimum	=>  10 
	} 
);
for my $href (@collections) {
	$DEBUG && print "Trying $searchString in " . $href->{name}. "...\n";
	$result=undef;
	$result = $mech->get( $url. "/" . $href->{name} . "?q=$searchString" );    			# limit the search to a collection
	ok ($mech->status == 200, "$host: Search for $searchString, within " .  $href->{name} . " collection") ; $count ++;
	ok (defined($result) , "Did we get content?") ; $count++;
	unlike  ($result->decoded_content, qr/We are sorry, something has gone wrong/, "Check for masked error") ; $count ++;
	unlike  ($result->decoded_content, qr/No results found for your search/, "Check for missing data") ; $count ++;

	# We are searching for this snippet: <strong>1</strong> - <strong>25</strong> of <strong>19,046</strong>
	$content = $result->decoded_content; 
	($match) = $content =~ qr/(<strong>1<\/strong> - <strong>\d+<\/strong> of <strong>)([\d,]+)/ ;

	ok (defined $2, "Extraction of count"); $count++;
	$resultsCounter = $2;
	$resultsCounter =~ tr/,//d; # output might contain commas
	if (defined $resultsCounter) {
		ok ($resultsCounter > $href->{minimum}, "Count of results within " . $href->{name} . ": $resultsCounter"); $count++;	# 14157 on Aug 12, 2015, but this will change over time
	}
}

done_testing $count;
