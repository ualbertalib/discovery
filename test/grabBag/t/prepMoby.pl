#!/usr/bin/perl -w
# Author: 	Neil MacGregor
# Date: 	Jun 9, 2015
# Purpose: 	Prepare a big file full of random strings, which will be used to feed data into ?JMeter? or other { solr | Discovery } testing tools. 
# 		Ripped out of the original moby.t, which (originally) did this inline
use strict;

my $bigWhale = "/var/tmp/mobyDick.txt";
#  Retrieve the text of Moby Dick from gutenberg.org, but only once, eh?
`wget -O $bigWhale.gz http://www.gutenberg.org/ebooks/2701.txt.utf-8` unless -e $bigWhale;

# Huh, Gutenberg started silently gzipping their downloads at one point: that's smart.  Also, annoying, since I have to deal with it


# To be clear, this file doesn't actually contain any commas, even though it's .csv -- the format is one-search-term-per-line
#
# Maybe we'll parameterize the number of words in the search string, sometime later?
#
#`sort -R /var/tmp/mobyDick.txt  | sed 's/,//g' | awk -F" " '{ print \$1 }' > /var/tmp/mobyRandom.csv`;  # Randomize it every time -- combatting Solr's caching efforts
#`sort -R /var/tmp/mobyDick.txt  | sed 's/,//g' | awk -F" " '{ print \$1, \$2 ;}' > /var/tmp/mobyRandom.csv`;  # Randomize it every time -- combatting Solr's caching efforts
`zcat $bigWhale.gz | sort -R | sed 's/,//g' | awk -F" " '{ print \$1, \$2, \$3;}' | sed 's/-//g' | egrep -v 'AND\$' | grep -v '^AND' | grep -v '^"AND' > /var/tmp/mobyRandom.csv`;  # Randomize it every time -- combatting Solr's caching efforts
