# Discovery Interface for University of Alberta Libraries
[![Build Status](https://travis-ci.org/ualbertalib/discovery.svg?branch=master)](https://travis-ci.org/ualbertalib/discovery)

This is the code base for the University of Alberta Libraries's
discovery platform. Based on [Project Blacklight](projectblacklight.org).

*   Depends on [Ruby](https://www.ruby-lang.org/en/) 2.1.5
*   Depends on an instance of [Solr](https://lucene.apache.org/solr/) with [this configuration](https://github.com/ualbertalib/blacklight_solr_conf)

## Architecture
![Discovery Architecture Diagram](docs/discovery_architecture.png)

## To get the application up and running for development:

1.  clone this repository (`git clone https://github.com/ualbertalib/discovery`)
2.  run `bundle install`
3.  run `bundle exec rake db:setup`
4.  Create the APIAuthentication.txt (containing your EBSCO credentials) and token.txt (empty) files
5.  `bundle exec rails s`
6.  Point your browser to **<http://localhost:3000/catalog>** or **<http://localhost:3000/results>**

## To run the tests:

Unit and Acceptance Tests

1.  `bundle install --without development production`
2.  `RAILS_ENV=test bundle exec rake db:create`
3.  `RAILS_ENV=test bundle exec rake db:migrate`
4.  `bundle exec rake spec`

Integration tests (run against <http://search-test.library.ualberta.ca/>)

1.  `cpan WWW::Mechanize && cpan JSON` to install perl dependencies
2.  `wget -O /var/tmp/mobyDick.txt http://www.gutenberg.org/ebooks/2701.txt.utf-8` your first visit to gutenberg might give you non utf-8 characters when it says, "hello stranger."
3.  `cd test/grabBag`
4.  `./allTests.pl`

## Additional Tasks for uat, staging and production

1.  `bundle exec rake assets:precompile` this can take several minutes
2.  `comfortable_mexican_sofa:cmssetup` to setup the CMS
3.  create cron jobs to ingest `bundle exec rake ingest[sfx]`, `bundle exec rake ingest[databases]` and clean session table `bundle exec rake sessions:cleanup`

## Ingest

The standard library cataloguing data format is [MARC](https://www.loc.gov/marc/marcdocz.html). MARC uses numeric fields to contain bibliographic information in the form of text strings that use a [content standard](https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description) to format the text and, perhaps more importantly, the punctuation. Each MARC field can be subdivided into alphabetical subfields which generally either a) containing repeated elements or b) subdivide the text string. MARC fields and subfields are often written out as e.g. **245$a** which means field number 245 (= title), subfield a.

In SolrMarc, the library currently being used to index Blacklight data, the mapping of MARC fields occurs [here](https://github.com/ualbertalib/discovery/blob/master/config/SolrMarc/symphony_index.properties) with more sophisticated data manipulation using BeanShell happening in [these scripts](https://github.com/ualbertalib/discovery/tree/master/config/SolrMarc/index_scripts). Once the fields have been mapped, they can be designated for search and/or display in the appropriate Solr config file (either schema.xml or solrconfig.xml).

`bundle exec rake ingest[collection]` where collection is mainly 'symphony', 'sfx' or 'databases'.  See `config/ingest.yml` for other collections. Most collections are expected to be represented by a file in a `./data` directory.

## Cataloguing Tool

This is proof-of-concept functionality. The requirement from cataloguing
staff was to have a way to see modified/updated records in the
appropriate Blacklight view (either Discovery or NEOS Discovery),
without having to wait overnight for the updated record to be reindexed.
Basically, what the cataloguing tool does is: presents a form where a
record ID can be entered; on form submission, the application downloads
the record from Symphony using
[z39.50](https://en.wikipedia.org/wiki/Z39.50); changes the id so that
the existing record isn't overwritten; indexes the new record in Solr
(using the index rake task);
redirects the user to the record view. Most of the logic for this is
held in a new controller (cataloguing_controller). 
