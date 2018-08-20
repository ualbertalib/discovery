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

$mech->get( $url );    			# Visit the default page

my $searchString="shakespeare"; 	# inspired by Sam's favourite test
my $count=0;
my $result; 
$DEBUG && print "Trying $searchString...\n";
eval {$result = $mech->submit_form( fields    => { q => $searchString, },);  };
ok ($mech->status == 200, "$host: Search for $searchString, defaults to symphony") ; $count ++;
ok (defined($result) , "Did we get content?") ; $count++;
unlike  ($result->decoded_content, qr/We are sorry, something has gone wrong/, "Check for masked error") ;   #  Ugh, in Prod, we try to return a pretty error, not a bare 500
$count ++;
unlike  ($result->decoded_content, qr/No results found for your search/, "Check for missing data") ; $count ++;

# We are searching for this snippet: <strong>1</strong> - <strong>25</strong> of <strong>19,046</strong>
my $content = $result->decoded_content; 
my $match;
($match) = $content =~ qr/(<strong>1<\/strong> - <strong>25<\/strong> of <strong>)([\d,]+)/ ;
if (defined $match) { 
	$DEBUG && print "I found a match\n";
	$DEBUG && print "The match was: $match\n\n";
	$DEBUG && print "extracted number was: $2\n" if defined $2;
	
} else {
	$DEBUG && print "No match found\n";
}

#like ($result->decoded_content, qr/(Books, media &amp; more.*\n.*>)(\d+)( results)/m, "Results contain a count of the number of books"); $count++;
like ($result->decoded_content, qr/(<strong>1<\/strong> - <strong>25<\/strong> of <strong>)([\d,]+)/m, "Results contain a count of the number of books") ; $count ++;
ok (defined $2, "Extraction of count successful"); $count++;
my $booksCounter = $2;
$booksCounter =~ tr/,//d; # output might contain commas
if (defined $booksCounter) {
	ok ($booksCounter > 14000, "Count of results should exceed 14,000, actual: $booksCounter"); $count++;	# 14157 on Aug 12, 2015, but this will change over time
}

# Now, repeat that for (EBSCO) Articles
#like ($result->decoded_content, qr/(Articles &amp; more.*\n.*>)(\d+)( results)/m, "Results contain a count of the number of articles"); $count++;
#ok (defined $2, "Extraction of count successful"); $count++;
#if (defined $2) {
	#ok ($2 > 4000, "Count of ebooks should exceed 4,000, actual: $2"); $count++;	# 4467 on Aug 12, 2015, but this will change if we get more
#}

# Journals
$result=undef;
$result = $mech->get( $url."/journals?q=shakespeare" );    			# limit the search to journals
ok ($mech->status == 200, "$host: Search for $searchString in Journals") ; $count ++;
ok (defined($result) , "Did we get content?") ; $count++;
unlike  ($result->decoded_content, qr/We are sorry, something has gone wrong/, "Check for masked error") ; $count ++;
unlike  ($result->decoded_content, qr/No results found for your search/, "Check for missing data") ; $count ++;
unlike  ($result->decoded_content, qr/We are sorry, the page you requested cannot be found</, "Check for bad page request") ; $count ++;
$content = $result->decoded_content; 
($match) = $content =~ qr/(<strong>1<\/strong> - <strong>\d+<\/strong> of <strong>)([\d,]+)/ ;
if (defined $match) { 
	$DEBUG && print "I found a match\n";
	$DEBUG && print "The match was: $match\n\n";
	$DEBUG && print "extracted number was: $2\n" if defined $2;
	
} else {
	$DEBUG && print "No match found\n";
}
like ($result->decoded_content, qr/(<strong>1<\/strong> - <strong>\d+<\/strong> of <strong>)([\d,]+)/m, "Results contain a count of the number of journals") ; $count ++;
ok (defined $2, "Extraction of count successful"); $count++;
$booksCounter = $2;
$booksCounter =~ tr/,//d; # output might contain commas
if (defined $booksCounter) {
	ok ($booksCounter > 10, "Count of results should exceed 14,000, actual: $booksCounter"); $count++;	# Just 20 matches found, 20180820
}

done_testing $count;
