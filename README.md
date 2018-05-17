Discovery Interface for University of Alberta Libraries
=======================================================

This is the code base for the University of Alberta Libraries's
discovery platform. Based on [Project
Blacklight](projectblacklight.org).

To get the application up and running:

1. clone this repository (via ssh: `git clone git@github.com:ualbertalib/discovery`)
2. run `bundle install`
3. run `rake db:migrate`
4. Create the APIAuthentication.txt (containing your EBSCO credentials) and token.txt (empty) files
5. `cd solr-jetty` & `java -jar start.jar &`
6. `rake ingest[symphony_test_set]`
7. `rake ingest[sfx_test_set]`
8. `rake ingest[databases]`
9. `rails s`
10. Point your browser to **http://localhost:3000**
11. Solr admin is available at **http://localhost:8983**
