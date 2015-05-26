#!/usr/bin/perl -w 
# Author: 	Neil MacGregor
# Date: 	July 10, 2012
# Version: 	Revision controlled, see: https://code.library.ualberta.ca/hg/era-test
# Purpose: 	Ensure that httpd is running; 
# Reference:	file://///libroot/ITS_Share/Unix/Projects/2012/Tin/testFramework.html

use Test::More tests => 1;  	# bump this number every time you add a new test to this file

use lib "../perllib";
use Webtest;			# Neil's custom module, hiding 40 lines of WWW::Mechanize complexity
$ENV{"USERID"} = "none"; $ENV{"PASSWORD"} = "none";
my $host="search-test.library.ualberta.ca"; 
$host = $ENV{"TARGETHOSTNAME"} if defined $ENV{"TARGETHOSTNAME"};
my $r= Webtest::basicWeb("https://$host");	# non-OO use of an OO method

# The test - A web status code of 500 means "connection failed", implying httpd is down!
ok ($r->code != 500 , "Simple httpd up/down, $host");  	
