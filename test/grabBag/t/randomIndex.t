#!/usr/bin/perl -w
# Ugh
use strict;
use WWW::Mechanize;
use JSON;
use Storable;
use Test::More tests => 11;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};

# setup
my $realm = "test";                                     # use the test realm by default
$realm = $ENV{"REALM"}  if defined $ENV{"REALM"};       # but load it from the environment variable, if it was specified
my $host="search-test.library.ualberta.ca";             # use the Test environment by default
# config.txt contains a serialized hash-of-hashes, configuration file for this set of tests, integrated with Jenkins parameters
my $lookup = retrieve 'config.txt';                   # get a static data structure from a file
$host = $lookup->{$realm}{'appserver'} if defined $lookup->{$realm}{'appserver'};
my $solrHost="solrcloud-test.library.ualberta.ca:8080";	# a default value -- the test realm
$solrHost = $lookup->{$realm}{'solr'} if defined $lookup->{$realm}{'solr'};
my $solrCollection="discovery-test";			# a default value, eg test realm
$solrCollection = $lookup->{$realm}{'solrCollection'} if defined $lookup->{$realm}{'solrCollection'};
$DEBUG && print "We're in $realm, so I'll be using appserver=$host with solrserver=$solrHost and solrCollection=$solrCollection\n";

my @randomSearches = &selectRandom($solrHost, $solrCollection);
print "==================\n";

my $mech = WWW::Mechanize->new();
my $url="https://$host";

$mech->get( $url );    		# Visit the sign_in page
like( $mech->content(), qr/University of Alberta Libraries/, "Contains the phrase 'University of Alberta Libraries'" );

foreach my $searchString (@randomSearches) {
  eval { $mech->submit_form( fields    => { q => "$searchString" } );  };     # the 'eval' is here to prevent this script from crashing, when Rails crashes & gives us poor results
  ok( $mech->status == 200, "$host: Searching for random string: $searchString" );
}


# ======================================================================================
sub selectRandom {
my $solrHost=shift;  # retrieve input parameter
my $solrCollection=shift;  # retrieve input parameter

my $mech = WWW::Mechanize->new();

# make an initial connection, in which solr will tell us the size of the index...
my $baseURL="http://$solrHost/solr/$solrCollection/select?&wt=json";    # parameterized !
my $rows=1;
$mech->get( $baseURL . "&rows=$rows"  );

my $initialjsonHashref = JSON->new->utf8->decode($mech->content);
my $page = int rand (int($initialjsonHashref->{ "response" }->{ "numFound" } / 10));
$DEBUG && print "Selecting page: $page\n";

$rows=10;
$mech->get( $baseURL . "&rows=$rows&start=$page" );
my $jsonHashref = JSON->new->utf8->decode($mech->content);

# Solr is *capable* of returning to you all 5.5M records, if you ask for them.   But by default it will return just 10 per "page" -- this is called pagination.
# And, you can tell it what page you want to start on... !

#  ->{ "response" }->{ "docs" } appears to be a doubly-nested array of hashes...  I don't understand why the array is double-nested
my @doc = $jsonHashref->{ "response" }->{ "docs" };

$mech = WWW::Mechanize->new();
my @search;
foreach my $outerLoop ( $jsonHashref->{ "response" }->{ "docs" } ) {
  foreach my $innerLoop (@$outerLoop) {
    push @search, $innerLoop->{ "title_display" }[0];
  }
}

return @search;
}
