#!/usr/bin/perl -w
# Author: 	Neil MacGregor
# Date: 	July 10, 2012
# Version: 	Revision controlled, see: https://code.library.ualberta.ca/hg/era-test
# Purpose: 	Ensure that httpd is running;
# Reference:	file://///libroot/ITS_Share/Unix/Projects/2012/Tin/testFramework.html

use Test::More tests => 1;  	# bump this number every time you add a new test to this file
use Storable;

use lib "../perllib";
use Webtest;			# Neil's custom module, hiding 40 lines of WWW::Mechanize complexity

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};

# setup
my $realm = "test";                                     # use the test realm by default
$realm = $ENV{"REALM"}  if defined $ENV{"REALM"};       # but load it from the environment variable, if it was specified
my $host="search-test.library.ualberta.ca";             # use the Test environment by default
# config.txt contains a serialized hash-of-hashes, configuration file for this set of tests, integrated with Jenkins parameters
my $lookup = retrieve 'config.txt';                   # get a static data structure from a file
$host = $lookup->{$realm}{'appserver'} if defined $lookup->{$realm}{'appserver'};
$DEBUG && print "We're in $realm, so I'll be using $host\n";

$ENV{"USERID"} = "none"; $ENV{"PASSWORD"} = "none";
my $r= Webtest::basicWeb("https://$host");	# non-OO use of an OO method

# The test - A web status code of 500 means "connection failed", implying httpd is down!
ok ($r->code != 500 , "Simple httpd up/down, $host");
