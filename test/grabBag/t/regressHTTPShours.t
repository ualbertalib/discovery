#!/usr/bin/perl -w
# Author: 	Neil MacGregor
# Date: 	May 25, 2015
# Purpose: 	A regression test searching the primary home page for links to the Hours application, that use http://hours...
# RevisionCntl: 
# Context: 	You can run this from your desktop machine (assuming it's Linux; untested on CYGWIN)
# 		You can run this from the application servers (dundee or austin, falkirk or forest, and even dover & york)
# 		You can run this from the Jenkins server (which doesn't generally have access to Dev)
# Ideas for improvement: This should take a parameter specifying which realm to test
use strict;
use WWW::Mechanize;
use Test::More;

my $mech = WWW::Mechanize->new();  				
my $realm = "test";					# use the test realm by default
$realm = $ENV{"REALM"}  if defined $ENV{"REALM"};	# but load it from the environment variable, if it was specified
my $host="search-test.library.ualberta.ca";    		# use the Test environment by default
# We should probably make this into an object, so as to avoid repetition
$host = "dundee.library.ualberta.ca" 		if $realm eq "dev";   # should I embed these in a datafile that's tied to a hash, shared by all the tests?
$host = "search-test.library.ualberta.ca" 	if $realm eq "test";
$host = "search.library.ualberta.ca" 		if $realm eq "prod";

my $url="https://$host";  
my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};

my $count=0;
eval { $mech->get( $url );  };  		# Visit the sign_in page
ok ($mech->status == 200, "$url initial page load");   $count++;

my @link  = $mech->links;		# retrieve a list of all the links 
my $holder; 
foreach $holder (@link) { 		# perform the test
	$DEBUG && print $holder->url . "\n";
	unlike ($holder->url, qr|http://hours|, "Links shouldn't match http://hours..., url: " . $holder->url ) or (defined $holder->text && diag ( "Text for that link was: " . $holder->text ));
	$count ++;
}

done_testing $count;
