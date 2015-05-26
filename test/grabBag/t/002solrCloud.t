#!/usr/bin/perl -w 
# Author: 	Neil MacGregor
# Date: 	July 10, 2012
# Version: 	Revision controlled, see: https://code.library.ualberta.ca/hg/era-test
# Purpose: 	Ensure that tomcat is running 
# Reference:	file://///libroot/ITS_Share/Unix/Projects/2012/Tin/testFramework.html
use Test::More tests => 1;  # bump this number every time you add a new website to be tested

use strict;
use lib "../perllib";
use lib "perllib";
use Webtest;

$ENV{"USERID"} = "none"; $ENV{"PASSWORD"} = "none";
my $host="search-test.library.ualberta.ca"; 
$host = $ENV{"TARGETHOSTNAME"}  if defined $ENV{"TARGETHOSTNAME"};
my $r = Webtest::basicWeb("https://$host");
ok ($r->code != 500 , "SolrCloud up/down test, $host");  # 500 means "connection failed", eg httpd is down!
