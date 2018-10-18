#!/usr/bin/perl -w
# Author:	Neil MacGregr
# Date: 	July 10, 2012
# Version: 	Revision Controlled, see: https://code.library.ualberta.ca/hg/era-test/
# Purpose:	Run all the tests that comprise the ERA testing codebase, display results
# Reference:	file://///home/nmacgreg/Unix/Projects/2012/Tin/testFramework.html
use strict;
use TAP::Harness;

# compose a list of all the test programs that we need to run:
my @test;
my $testDir = "t/"; # a local directory named t
opendir(my $dh, $testDir) || die;
foreach (readdir $dh) {
  m/\.t$/ && do { push @test, $testDir . $_; next; }; # find files that end with ".t"
}
closedir $dh;
@test = sort (@test);   # provide strong ordering based on filename!

# hare are the arguements we'll supply to the TAP Harness
my %args = (
    verbosity => 1,
    lib     => [ 'perllib' ],
 );
my $harness = TAP::Harness->new( \%args );   	# create object
exit $harness->runtests(@test)->failed;  	# run the sorted tests, returning the number of tests that failed, RE: Jenkins
