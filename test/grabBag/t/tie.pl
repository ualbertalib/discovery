#!/usr/bin/perl -w 
# use this script to make updates to config.txt, which is merely this data-structure, serialized.
# It's unlikely you'll need to change this data, unless you change the structure of the application!

use Storable;
# I want a simple object that allows me to translate "Production" into the hostnames search.library.ualberta.ca, and solr.librar
my %realm = (  
		'prod' => {
				'solr' 			=> 'tottenham.library.ualberta.ca:8080',
				'appserver'		=> 'search.library.ualberta.ca' ,
				'solrCollection'	=> 'discovery' 
			  },
		'test' => {
				'solr' 			=> 'solr-test.library.ualberta.ca:8080',
				'appserver'		=> 'search-test.library.ualberta.ca' ,
				'solrCollection'	=> 'discovery-test' 
			 },
		'dev' => {
				'solr' 			=> 'austin.library.ualberta.ca:8983',  # jetty
				'appserver'		=> 'austin.library.ualberta.ca' ,
				'solrCollection'	=> 'collection1' 
			 }
);

#print "The solr server for production is: " . $realm{'production'}{'solr'} . "\n";
#print "The app server for test is: " . $realm{'test'}{'appserver'} . "\n";

store \%realm, "config.txt";
