# Discovery Interface for University of Alberta Libraries
[![Build Status](https://travis-ci.org/ualbertalib/discovery.svg?branch=master)](https://travis-ci.org/ualbertalib/discovery)

This is the code base for the University of Alberta Libraries's
discovery platform. Based on [Project Blacklight](projectblacklight.org).

*   Depends on [Ruby](https://www.ruby-lang.org/en/) 2.1.5
*   Depends on an instance of [Solr](https://lucene.apache.org/solr/) with [this configuration](https://github.com/ualbertalib/blacklight_solr_conf)
*   If you wish to use docker for the datastores install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/) first.

## Architecture
![Discovery Architecture Diagram](docs/discovery_architecture.png)

## To get the application up and running for development:

1.  clone this repository (`git clone https://github.com/ualbertalib/discovery`)
2.  run `docker-compose -f docker-compose.lightweight.yml up -d`
3.  run `bundle install`
4.  run `bundle exec rake db:setup`
5.  Create the APIAuthentication.txt (containing your EBSCO credentials) and token.txt (empty) files
6.  `RAILS_ENV=ingest bundle exec rake ingest[database_test_set] && RAILS_ENV=ingest bundle exec rake ingest[sfx_test_set] && RAILS_ENV=ingest bundle exec rake ingest[symphony_test_set]`
6.  `bundle exec rails s`
7.  Point your browser to **<http://localhost:3000/catalog>** or **<http://localhost:3000/results>**

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
2.  `bundle exec rake comfortable_mexican_sofa:cmssetup` to setup the CMS
3.  create cron jobs to ingest `RAILS_ENV=ingest bundle exec rake ingest[sfx]`, `RAILS_ENV=ingest bundle exec rake ingest[databases]` and clean session table `bundle exec rake sessions:cleanup`

## Ingest

The standard library cataloguing data format is [MARC](https://www.loc.gov/marc/marcdocz.html). MARC uses numeric fields to contain bibliographic information in the form of text strings that use a [content standard](https://en.wikipedia.org/wiki/International_Standard_Bibliographic_Description) to format the text and, perhaps more importantly, the punctuation. Each MARC field can be subdivided into alphabetical subfields which generally either a) containing repeated elements or b) subdivide the text string. MARC fields and subfields are often written out as e.g. **245$a** which means field number 245 (= title), subfield a.

In SolrMarc, the library currently being used to index Blacklight data, the mapping of MARC fields occurs [here](https://github.com/ualbertalib/discovery/blob/master/config/SolrMarc/symphony_index.properties) with more sophisticated data manipulation using BeanShell happening in [these scripts](https://github.com/ualbertalib/discovery/tree/master/config/SolrMarc/index_scripts). Once the fields have been mapped, they can be designated for search and/or display in the appropriate Solr config file (either schema.xml or solrconfig.xml).

`RAILS_ENV=ingest bundle exec rake ingest[collection]` where collection is mainly 'symphony', 'sfx' or 'databases'.  See `config/ingest.yml` for other collections. Most collections are expected to be represented by a file in a `./data` directory.


