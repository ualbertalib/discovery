#!/usr/bin/perl -w
# Author: 	Tricia Jenkins
# Date: 	Oct 2, 2018
# Purpose: 	A regression test, validating that the correct number of libraries exist.  From 3.0.85 deployment issue.
# RevisionCntl: github, ualbertalib/discovery
# Context: 	the blacklight/discovery project\
use strict;
use WWW::Mechanize;
use HTML::TreeBuilder::XPath;
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
my $url="https://$host/advanced";

my $count=0;

$DEBUG && print "Trying $url ...\n";
my $result=undef;
$result = $mech->get( $url );
ok ($mech->status == 200, "$host: Visit advanced search page") ; $count ++;
ok (defined($result) , "Did we get content?") ; $count++;
unlike  ($result->decoded_content, qr/We are sorry, something has gone wrong/, "Check for masked error") ; $count ++;

# We want to count Library locations to make sure that they are all there
my $tree = HTML::TreeBuilder->new_from_content( $result->decoded_content ) ;
my $libraries = $tree->findnodes( '/html/body/div[1]/div[6]/div[2]/div/div/div[1]/form/div/div[3]/div/div/div[3]/div[2]/div/ul/li' );
my $num_libraries = $libraries->size() ;
ok ($libraries->size() > 50, "Count of libraries $num_libraries"); $count++;	# 54 on Sept 13, 2018, 53 on Dec 5, 2018 but this may change over time
$tree->delete;

done_testing $count;
