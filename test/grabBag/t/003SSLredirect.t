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
# Ideas for improvement:
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
my $url="http://$host";  

my $response = $mech->get( $url );    		# Visit the default home page
# did I get redirected to the https interface? 
#print "Was this a redirect:  " . $response->is_redirect . "\n";
#print "The code was: " . $response->code . "\n";
#print "The base was: " . $response->base . "\n";
like ($response->base, qr/^https:/, "Redirect to https");

done_testing 1;
