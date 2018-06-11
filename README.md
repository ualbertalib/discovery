Discovery Interface for University of Alberta Libraries
=======================================================
[![Build Status](https://travis-ci.org/ualbertalib/discovery.svg?branch=master)](https://travis-ci.org/ualbertalib/discovery)

This is the code base for the University of Alberta Libraries's
discovery platform. Based on [Project
Blacklight](projectblacklight.org).

Depends on ruby 2.1.5

To get the application up and running for development:

1. clone this repository (`git clone https://github.com/ualbertalib/discovery`)
2. run `bundle install`
3. run `bundle exec rake db:setup`
4. Create the APIAuthentication.txt (containing your EBSCO credentials) and token.txt (empty) files
5. `bundle exec rails s`
6. Point your browser to **http://localhost:3000/catalog** or **http://localhost:3000/results**

To run the tests:

Unit and Acceptance Tests

1. `bundle install --without development production`
2. `RAILS_ENV=test bundle exec rake db:create`
3. `RAILS_ENV=test bundle exec rake db:migrate`
4. `bundle exec rake spec`

Integration tests (run against http://search-test.library.ualberta.ca/)

1. `cpan WWW::Mechanize && cpan JSON` to install perl dependencies
2. `wget -O /var/tmp/mobyDick.txt http://www.gutenberg.org/ebooks/2701.txt.utf-8` your first visit to gutenberg might give you non utf-8 characters when it says, "hello stranger."
3. `cd test/grabBag`
3. `./allTests.pl`

