#!/usr/bin/perl -w
# Ugh
use strict;
use WWW::Mechanize;
use JSON; 
use Test::More tests => 11; 

my @randomSearches = &selectRandom;
print "==================\n";

my $mech = WWW::Mechanize->new();  				
my $host="search-test.library.ualberta.ca";
$host = $ENV{"TARGETHOSTNAME"}  if defined $ENV{"TARGETHOSTNAME"};
my $url="https://$host";

$mech->get( $url );    		# Visit the sign_in page
like( $mech->content(), qr/Search Library Resources/, "Contains the phrase 'Search Library Resources'" );
foreach my $searchString (@randomSearches) {
	eval { $mech->submit_form( fields    => { q => "$searchString" } );  };     # the 'eval' is here to prevent this script from crashing, when Rails crashes & gives us poor results
	ok( $mech->status == 200, "$host: Searching for random string: $searchString" );
}

# ======================================================================================
sub selectRandom {
my $mech = WWW::Mechanize->new();  				

# make an initial connection, in which solr will tell us the size of the index...
my $solrHost="solr-test.library.ualberta.ca";
$solrHost=$ENV{"SOLRHOSTNAME"}  if defined $ENV{"SOLRHOSTNAME"};
my $baseURL="http://$solrHost:8080/solr/discovery-test/select?&wt=json";    # does this need to be parameterized, a la  $host ... probably, for Jenkins
my $rows=1;
$mech->get( $baseURL . "&rows=$rows"  );

my $initialjsonHashref = JSON->new->utf8->decode($mech->content);
my $page = int rand (int($initialjsonHashref->{ "response" }->{ "numFound" } / 10));
print "Selecting page: $page\n";

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
		push @search, $innerLoop->{ "title_t" }[0];
	}
}

return @search;
} 
