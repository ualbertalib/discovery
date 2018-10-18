#!/usr/bin/perl -w
# Author: 	Neil MacGregor
# Date: 	July 10, 2012
# Version: 	Revision controlled, see: https://code.library.ualberta.ca/hg/era-test
# Purpose: 	Ensure that tomcat is running
# Reference:	file://///libroot/ITS_Share/Unix/Projects/2012/Tin/testFramework.html
use Test::More tests => 1;  # bump this number every time you add a new website to be tested
use Storable;

use strict;
use lib "../perllib";
use lib "perllib";
use Webtest;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};

# setup
my $realm = "test";                                     # use the test realm by default
$realm = $ENV{"REALM"}  if defined $ENV{"REALM"};       # but load it from the environment variable, if it was specified
my $host="search-test.library.ualberta.ca";             # use the Test environment by default
# config.txt contains a serialized hash-of-hashes, configuration file for this set of tests, integrated with Jenkins parameters
my $lookup = retrieve 'config.txt';                   # get a static data structure from a file
$host = $lookup->{$realm}{'solr'} if defined $lookup->{$realm}{'solr'};
$DEBUG && print "We're in $realm, so I'll be using $host\n";


$ENV{"USERID"} = "none"; $ENV{"PASSWORD"} = "none";
my $r;
$r = Webtest::basicWeb("http://$host");
ok ($r->code != 500 , "SolrCloud up/down test, $host");  # 500 means "connection failed", eg httpd is down!
