# Author:	Neil MacGregor
# Date: 	Aug 1, 2012
# Version: 	This file is revision-controlled, see https://code.library.ualberta.ca/hg/era-test
# Purpose:	This inherits from LFA.pm.  This is the Log File Adaptor for catalina.out
#

use strict;
package Catalina;
use base qw/LFA/;

use Fcntl qw(SEEK_END SEEK_CUR);	# needed for calls to seek(), below

# Constructor for this subclass calls the superclass's constructor
sub new {
my $this = shift;
my $class = ref ($this) || $this;

my $self = $class->SUPER::new("/usr/share/tomcat6/logs/catalina.out");

# sorry, this is a bit of a maintenance hassle... you MUST have a description
# for each word you want to use, or it won't get set to zero, in the loop below
# Hashref within a hashref <sigh>
# These descriptions are good documentation for people who may follow!
$self->{"description"}->{"Total"}		="Total number of lines processed";  #special
#
$self->{"description"}->{"OOMECount"}		="Out of Memory Errors";
$self->{"description"}->{"openFiles"}	 	="Too many open file errors";
$self->{"description"}->{"severeCount"}		="SEVERE errors";
$self->{"description"}->{"fedoraFAIL"}		="Fedora failed";
$self->{"description"}->{"catalinaStartup"}	="Catalina startup";
$self->{"description"}->{"fedorasqlPool"}	="Fedora DB fail";
$self->{"description"}->{"sqlPool"}		="PoolableConnectionFactory";
$self->{"description"}->{"solr"}		="Basic solr";
$self->{"description"}->{"plainInfo"}		="Plain INFO";
$self->{"description"}->{"plainDebug"}		="Plain DEBUG";
$self->{"description"}->{"plainWarn"}		="Plain WARN";
$self->{"description"}->{"deployCount"}		="Deploy count";
$self->{"description"}->{"stackTrace"}		="'at' stacktrace";
$self->{"description"}->{"blank"}		="Blank lines";
$self->{"description"}->{"oaiIdentify"}		="Missing oai:Identify object from Fedora-Commons";
$self->{"description"}->{"tmap"}		="tmap table is missing from riTriples DB";
$self->{"description"}->{"SQLerr"}		="MySQL syntax error";
$self->{"description"}->{"proaiStreamErr"}	="proai stream error";
$self->{"description"}->{"severeSocket"}	="SEVERE error, cannot open file, out of memory";
$self->{"description"}->{"OOMfiles"}		="Lack of memory, cannot open file";
#
$self->{"description"}->{"unknown"}		="Unrecognized lines";	# special

# initialize the count to zero
foreach my $key (keys %{$self->{"description"}}) { # dereference hashref-within-hashref
  $self->{"counter"}->{$key} = 0;
}

# by default, skip forward to the end of the file
$self->goToEnd;
#bless $self, $class;
return $self;
}

# ==========================================================================
# Walk down the log file, looking for regular expressions we know, and counting them as we go
# Returns a hashref of the counts we found
sub analyzeLog {
my $self=shift;

# this is an ordered list of regex's - the order is critical.  Place more specific regexe's first, before
# more general ones like "INFO.*"
#my $OOMECount=0; my $openFiles = 0; my $severeCount = 0; my $unknown=0; my $fedoraFAIL=0; my $catalinaStartup=0; my $plainInfo=0;
#my $plainDebug=0; my $plainWarn=0; my $solr=0; my $fedorasqlPool=0; my $sqlPool = 0; my $stackTrace=0; my $deployCount=0; my $blank=0;
foreach ($self->next) {
  /java.lang.OutOfMemoryError: unable to create new native thread/ 	&& do { $self->{"counter"}->{"OOMECount"}++; next; };
  /java.io.FileNotFoundException:.*(Too many open files)/ 		&& do { $self->{"counter"}->{"openFiles"}++; next; };
  /FEDORA STARTUP ERROR|Fedora startup failed/				&& do { $self->{"counter"}->{"fedoraFAIL"}++; next; };
  /INFO: Server startup in / 						&& do { $self->{"counter"}->{"catalinaStartup"}++; next; };
  /org.apache.solr/							&& do { $self->{"counter"}->{"solr"}++; next; };
  /fedora.*Cannot create PoolableConnectionFactory/			&& do { $self->{"counter"}->{"fedorasqlPool"}++; next; };
  /Cannot create PoolableConnectionFactory/				&& do { $self->{"counter"}->{"sqlPool"}++; next; };
  /404.*fedora\/get\/oai:Identify\/Identify.xml/ 				&& do { $self->{"counter"}->{"oaiIdentify"}++; next;};
  /Table 'riTriples.*tmap' doesn't exist/					&& do { $self->{"counter"}->{"tmap"}++; next;};
  /You have an error in your SQL syntax/					&& do { $self->{"counter"}->{"SQLerr"}++; next;};
  /Error writing stream to file in cache/					&& do { $self->{"counter"}->{"proaiStreamErr"}++; next;};
  /SEVERE: Socket accept failed/ 						&& do { $self->{"counter"}->{"severeSocket"}++; next; };
  /Too many open files/ 							&& do { $self->{"counter"}->{"OOMfiles"}++; next; };
  # These are boilerplate
  /INFO:* / 								&& do { $self->{"counter"}->{"plainInfo"}++; next; };
  /DEBUG / 								&& do { $self->{"counter"}->{"plainDebug"}++; next; };
  /^WARNING: |WARN /							&& do { $self->{"counter"}->{"plainWarn"}++; next; };
  /SEVERE/ 								&& do { $self->{"counter"}->{"severeCount"}++; next; };
  / init$| start$| load$| deployDescriptor$/				&& do { $self->{"counter"}->{"deployCount"}++; next; };
  /\s*at /								&& do { $self->{"counter"}->{"stackTrace"}++; next; };
  /^\s*$|^\**$/								&& do { $self->{"counter"}->{"blank"}++; next; };   # whitespace, or decorative  ****'s
  # this last one is a catch-all for anything that didn't match, above...
  /.*/ 									&& do { $self->{"counter"}->{"unknown"}++; next; };

}
$self->{"counter"}->{"Total"}=0;
foreach my $key (keys %{$self->{"description"}}) { # dereference hashref-within-hashref
  $self->{"counter"}->{"Total"} += $self->{"counter"}->{$key}   unless $key eq "Total";
}
return $self->{"counter"};
} # end sub analyzeLog()


1; # don't remove this critical last line
