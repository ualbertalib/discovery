package Webtest;
use strict;
use WWW::Mechanize;

sub new {
my $this = shift;
my $class = ref ($this) || $this;

my $self = {};

bless $self, $class;
return $self;
}

# This routine uses WWW::Mechanize to connect to tthe webserver given as a parameter
sub basicWeb {
my $self=shift;
my $url=shift; # Note, Makes no attempt to validate the URL string... room for improvement!
$url = $self unless defined $url;
die "You didn't supply a URL"  unless defined $url && $url =~ m/^http/;

my $DEBUG = 0;  # Controls verbosity of output
$DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"}; # inherits from the environment
# retrieve credentials
my $userid   = $ENV{"USERID"} ;
my $password = $ENV{"PASSWORD"} ;
die 'You must define $USERID and $PASSWORD environment variables to run this script' unless  ( defined $userid && defined $password );

my $mech = WWW::Mechanize->new ( autocheck => 0 );
$mech-> add_header ( Accept =>"text/html, text/plain, image/*" ); # necessary to get around mod_security; don't wanna get flagged!
$mech-> credentials( $userid, $password );
my $response = $mech->get($url);

# Fiddly bits here test whether the content looks like somthing rational
return $response;
}

1;
