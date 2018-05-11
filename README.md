Discovery Interface for University of Alberta Libraries
=======================================================
[![Build Status](https://travis-ci.org/ualbertalib/discovery.svg?branch=master)](https://travis-ci.org/ualbertalib/discovery)

This is the code base for the University of Alberta Libraries's
discovery platform. Based on [Project
Blacklight](projectblacklight.org).

Depends on ruby 2.4
If you wish to use docker for the datastores install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/) first.

To get the application up and running for development:

1. clone this repository (`git clone https://github.com/ualbertalib/discovery`)
2. run `docker-compose -f docker-compose.lightweight.yml up -d`
3. run `bundle install`
4. run `bundle exec rake db:setup`
5. Create the APIAuthentication.txt (containing your EBSCO credentials) and token.txt (empty) files
6. `bundle exec rake ingest[symphony_test_set]`
7. `bundle exec rake ingest[sfx_test_set]`
8. `bundle exec rake ingest[database_test_set]`
9. `bundle exec rails s`
10. Point your browser to **http://localhost:3000/catalog** or **http://localhost:3000/results**
11. Solr admin is available at **http://localhost:8983** but note that the qt is `standard` not the default `/select`

To run the tests for the application:

`bundle exec rake spec`

# Discovery Docker Image


## What is this?

This is the image used for User Acceptance Testing (UAT) by the University of Alberta. 
Our hope is that if anyone wants to get a demo of our repo up and running they will
be able to use this as a starting point.


## Requirements

Ensure you have [Docker (1.13.0+)](https://docs.docker.com/engine/installation/) and 
[Docker Compose (1.10.0+)](https://docs.docker.com/compose/install/) installed


## In this Docker Container

In the Docker Container is minimal dependencies (database client and javascript libraries) 
to run the Discovery rails application on port 3000. It is based on the ruby:2.4 image maintained 
by the Docker Community.


## Usage

Expected usage is with Docker Compose `docker-compose up -d` which will provision 
containers for the datastores and setup nginx to serve the application on port 3002.

See [Developer Handbook Docker Usage Section](https://github.com/ualbertalib/Developer-Handbook/tree/master/Docker#docker-usage)

### Updating Docker Hub

* Image will be updated automagically using hooks upon merge to the master branch of [this project on github](https://github.com/ualbertalib/discovery)
* Find us on [Docker Hub](https://hub.docker.com/r/ualbertalib/discovery)

### Upgrading local container

Expected usage is with Docker Compose `docker-compose pull` which will seek out the latest
image of Discovery from Docker Hub.

See [Developer Handbook Updating the local container](https://github.com/ualbertalib/Developer-Handbook/tree/master/Docker#updating-local-container)


## Frequently used commands

See [Developer Handbook](https://github.com/ualbertalib/Developer-Handbook/tree/master/Docker#frequently-used-commands)

## Special notes / warnings / gotchas