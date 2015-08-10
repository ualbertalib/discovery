#!/usr/bin/perl -w
# Author: 	Neil MacGregor
# Date: 	May 25, 2015
# Purpose: 	A regression test searching the primary home page for links to the Hours application, that use http://hours...
# RevisionCntl: 
# Context: 	You can run this from your desktop machine (assuming it's Linux; untested on CYGWIN)
# 		You can run this from the application servers (dundee or austin, falkirk or forest, and even dover & york)
# 		You can run this from the Jenkins server (which doesn't generally have access to Dev)
use strict;
use WWW::Mechanize;
use Test::More;
use Storable;
use feature qw(switch);

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};

# setup
my $realm = "test";					# use the test realm by default
$realm = $ENV{"REALM"}  if defined $ENV{"REALM"};	# but load it from the environment variable, if it was specified
my $host="search-test.library.ualberta.ca";    		# use the Test environment by default
# config.txt contains a serialized hash-of-hashes, configuration file for this set of tests, integrated with Jenkins parameters
my $lookup = retrieve 'config.txt'; 			# get a static data structure from a file
$host = $lookup->{$realm}{'appserver'} if defined $lookup->{$realm}{'appserver'};
$DEBUG && print "We're in $realm, so I'll be using $host\n";

my $url="https://$host";  

my $count=0;
my $mech = WWW::Mechanize->new();  				
eval { $mech->get( $url );  };  		# Visit the sign_in page
ok ($mech->status == 200, "$url initial page load");   $count++;

my $searchString="shakespeare";
eval { $mech->submit_form( fields    => { q => $searchString, },);  };
ok ($mech->status == 200, "$host: Search for $searchString") ; $count ++;

my @link  = $mech->links;		# retrieve a list of all the links 
my $holder; 
foreach $holder (@link) { 		# perform the test
	$DEBUG && print $holder->url . "\n";
	given ($holder->url){
		when (qr|http://webapps.srv.ualberta.ca|) {  next; }
		when (qr|http://weblogin.srv.ualberta.ca|) {  next; }
		when (qr|http://www.onecard.ualberta.ca|) {  next; }
		when (qr|http://www.campusmap.ualberta.ca|) {  next; }
		when (qr|http://www.ualberta.ca|) {  next; }
		when (qr|http://www.copyright.ualberta.ca|) {  next; }
		when (qr|http://login.ezproxy.library.ualberta.ca|) {  next; }   # an ebsco problem, here!
	}
	unlike ($holder->url, qr|http://|, "Links shouldn't match http://..., url: " . $holder->url ) or (defined $holder->text && diag ( "Text for that link was: " . $holder->text ));
	$count ++;
}

done_testing $count;
