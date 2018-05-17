Discovery Interface for University of Alberta Libraries
=======================================================

This is the code base for the University of Alberta Libraries's
discovery platform. Based on [Project
Blacklight](projectblacklight.org).

Depends on ruby 2.1.5
If you wish to use docker for the datastores install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/) first.

To get the application up and running for development:

1. clone this repository (`git clone https://github.com/ualbertalib/discovery`)
2. run `bundle install`
3. run `docker-compose -f docker-compose.lightweight.yml up -d`
4. run `bundle exec rake db:migrate`
5. Create the APIAuthentication.txt (containing your EBSCO credentials) and token.txt (empty) files
6. `bundle exec rake ingest[symphony_test_set]`
7. `bundle exec rake ingest[sfx_test_set]`
8. `bundle exec rake ingest[databases]`
9. `bundle exec rails s`
10. Point your browser to **http://localhost:3000/catalog**
11. Solr admin is available at **http://localhost:8983**
