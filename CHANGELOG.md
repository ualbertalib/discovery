# Changelog
All notable changes to Discovery project will be documented in this file. Discovery is the University of Alberta Library's catalogue interface, built using Blacklight: http://projectblacklight.org/. https://search.ualberta.ca/.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and releases in Discovery project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.2.1] - 2020-05-22

### Fixed
- fixed hathitrust mixed content blocking [PR#1999](https://github.com/ualbertalib/discovery/pull/1999)

## [3.2.0] - 2020-05-21

### Added
- add generator to prep files for SolrMarc before ingest [#1939](https://github.com/ualbertalib/discovery/issues/1939)
- add hathitrust ETAS access [#1973](https://github.com/ualbertalib/discovery/issues/1973)

## [3.1.1] - 2020-04-22

### Fixed
- abort `symphony_nightly` if data files do not exist. [PR#1961](https://github.com/ualbertalib/discovery/pull/1961)
- removed reference to error variable in Rollbar errors [PR#1962](https://github.com/ualbertalib/discovery/pull/1962)

### Removed
- removed paragraph in record views related to Browzine, cancelled as of April 30, 2020. [PR#1964]https://github.com/ualbertalib/discovery/pull/1964

## [3.1.0] - 2020-04-06

### Removed
- update tests to address deprecations [PR#1901](https://github.com/ualbertalib/discovery/pull/1901)

### Changed
- data sanity regression test values for databases [PR#1915](https://github.com/ualbertalib/discovery/pull/1915)
- hours and wording of question for BPSC request form [#1889](https://github.com/ualbertalib/discovery/issues/1889)
- prepare for incoming library short codes [#1843](https://github.com/ualbertalib/discovery/issues/1843)
- denormalize library locations [#1843](https://github.com/ualbertalib/discovery/issues/1843)

### Added
- create backup tables for library and location [#1843](https://github.com/ualbertalib/discovery/issues/1843)
- add symphony_nightly generator [#1843](https://github.com/ualbertalib/discovery/issues/1843)

### Fixed
- N+1 query memoized for location, status, item type and circulation rules [PR#1937](https://github.com/ualbertalib/discovery/pull/1937)

## [3.0.116] - 2020-02-02

### Added
- Added "See License Terms" link to SFX e-journal record holdings. [#1893]

## [3.0.115] - 2019-12-20

### Changed
- Path to the SFX data file on the new SFX server (for e-journal ingest) [#1871](https://github.com/ualbertalib/discovery/issues/1871)
- Update path in spec/fixtures as well. [#1872](https://github.com/ualbertalib/discovery/issues/1872)

### Added
- concordin to location facet mapping for use at index time [#1811](https://github.com/ualbertalib/discovery/issues/1811)

## [3.0.114] - 2019-11-26

### Changed
- create an 'Unknown' entry for ActiveRecord::RecordNotFound events to limit Rollbar errors [#1853](https://github.com/ualbertalib/discovery/issues/1853)

### Fixed
- searches failing with no location_tesim [#1811](https://github.com/ualbertalib/discovery/issues/1811)

## [3.0.113] - 2019-11-01

### Fixed
- missing variable declaration in Location error handling [#1824](https://github.com/ualbertalib/discovery/issues/1824)
- typo of CirculationRule in Holdings Helper [#1823](https://github.com/ualbertalib/discovery/issues/1823)

### Changed
- updated occurences of University of Alberta Libraries to Library (new name) [#1813](https://github.com/ualbertalib/discovery/issues/1813)

## [3.0.112] - 2019-10-25

### Added
- Add version file and meta generator tag [#1343](https://github.com/ualbertalib/discovery/issues/1343)

### Changed
- for Docker add bundler build config to make sassc gem portable [#1796](https://github.com/ualbertalib/discovery/issues/1796)
- changed migration which will change db/table/col to utf8 encoding [#1800](https://github.com/ualbertalib/discovery/issues/1800)

## [3.0.111] - 2019-10-23

### Changed
- create migration which will change db/table/col to utf8mb4 encoding [PR#1801](https://github.com/ualbertalib/discovery/pull/1801)
- re-dockerize to use modern ruby docker image and puma [PR#1805](https://github.com/ualbertalib/discovery/pull/1805)

## [3.0.110] - 2019-09-24

### Security
- Bump devise from 4.7.0 to 4.7.1 [PR#1762](https://github.com/ualbertalib/discovery/pull/1762)

### Fixed
- Made google analytics work without turbolinks [#1516](https://github.com/ualbertalib/discovery/issues/1516)

### Changed
- create migration and models to replace status, item type, circulation rules, library and locations data from static config files and refactor to replace related constants [#1273](https://github.com/ualbertalib/discovery/issues/1273)
- adding italics around "Place hold with barcode and PIN" to increase visability. [PR#1804](https://github.com/ualbertalib/discovery/pull/1804)

## [3.0.109] - 2019-08-20

### Security
- Bump nokogiri from 1.10.3 to 1.10.4 [PR#1743](https://github.com/ualbertalib/discovery/pull/1743)

### Added
- Index invalid ISSN. Ensure a new index is built after this release and blacklight_solr_conf is deployed  [#1715](https://github.com/ualbertalib/discovery/issues/1715)
- Added feature tests for sending a correction [#1727](https://github.com/ualbertalib/discovery/issues/1727)
- Added feature tests for text/email me features [#1722](https://github.com/ualbertalib/discovery/issues/1722)
- Added feature tests for an item having and not having an ill link [#1740](https://github.com/ualbertalib/discovery/issues/1740)

### Changed
- Modified display of multiple contents note fields [#1518](https://github.com/ualbertalib/discovery/issues/1518)
- RCRF Request form wording change [#1723](https://github.com/ualbertalib/discovery/issues/1723)

### Fixed
- Fixed broken u of a license image [#1676](https://github.com/ualbertalib/discovery/issues/1676)

## [3.0.108] - 2019-08-01

### Security
- ensure that redirects on request forms cannot be used to redirect away from the site [#1720](https://github.com/ualbertalib/discovery/issues/1720)

### Changed
- Made BPSC and RCRF forms redirect to the referring item page [#1443](https://github.com/ualbertalib/discovery/issues/1443)
- production config change! updated to set default url as search.library.ualberta.ca related to refworks export from bookmarks [#1484](https://github.com/ualbertalib/discovery/issues/1484)
- Made display of publication year field not remove information [#1367](https://github.com/ualbertalib/discovery/issues/1367)

### Added
- Added feature tests for search history [#1725](https://github.com/ualbertalib/discovery/issues/1725)
- Added missing picture books status [#1690](https://github.com/ualbertalib/discovery/issues/1690)
- Added feature tests for chained subject linking [#1708](https://github.com/ualbertalib/discovery/issues/1708)
- Added feature tests for item author links [#1710](https://github.com/ualbertalib/discovery/issues/1710)
- Added feature tests for item holding table being proper [#1712](https://github.com/ualbertalib/discovery/issues/1712)
- Added feature tests for journal search results containing proper metadata [#1704](https://github.com/ualbertalib/discovery/issues/1704)
- Added optional email address field to send correction form [#1391](https://github.com/ualbertalib/discovery/issues/1391)
- Added additional text for BPSC request form [#1728](https://github.com/ualbertalib/discovery/issues/1728)

### Fixed
- failing grabBag test for number of libraries displayed on the advanced search page after bootstrap refactor [PR#1701](https://github.com/ualbertalib/discovery/pull/1701)

## [3.0.107] - 2019-07-09

### Added
- Added feature tests for search sorting [#1627](https://github.com/ualbertalib/discovery/issues/1627)
- Add feature tests for search results having logo if UofA holding [#1632](https://github.com/ualbertalib/discovery/issues/1632)
- Added feature tests for search results per page [#1630](https://github.com/ualbertalib/discovery/issues/1630)
- Added feature tests for search faceting [#1622](https://github.com/ualbertalib/discovery/issues/1622)
- Added the ability to search by a cancelled isbn (020$z.) Ensure a new index is built after this release and blacklight_solr_conf is deployed [#1645](https://github.com/ualbertalib/discovery/issues/1645)
- Added feature tests for search results containing proper metadata [#1670](https://github.com/ualbertalib/discovery/issues/1670)
- Added feature tests for clearing search terms [#1668](https://github.com/ualbertalib/discovery/issues/1668)
- Added Kule collection ingest task [#957](https://github.com/ualbertalib/discovery/issues/957)

## Changed
- removed link from Series title on catalog show page [#1542](https://github.com/ualbertalib/discovery/issues/1542)
- Upgrade bootstrap to version 4.3.1 [#1601](https://github.com/ualbertalib/discovery/issues/1601)
- Change Layout of Record page [#1426](https://github.com/ualbertalib/discovery/issues/1426)
- Made export/request features language consistent [#1607](https://github.com/ualbertalib/discovery/issues/1607)

### Fixed
- fixed error in dangerfile [#1602](https://github.com/ualbertalib/discovery/issues/1602)
- align label/url for related resources [#1584](https://github.com/ualbertalib/discovery/issues/1584)

## [3.0.106] - 2019-04-23

### Added
- Added feature tests for search results having google book jackets [#1635](https://github.com/ualbertalib/discovery/issues/1635)

### Security
- bump nokogiri from 1.10.2 to 1.10.3 [PR#1614](https://github.com/ualbertalib/discovery/pull/1614)

### Added
- Added new languages location into statuses.yml [#1592](https://github.com/ualbertalib/discovery/issues/1592)
- Add danger that enforces requirements for PR to Discovery [#1564](https://github.com/ualbertalib/discovery/issues/1564)
- feature and integration tests for emailing bookmarks [#1580](https://github.com/ualbertalib/discovery/issues/1580)

### Removed
- Remove subtitle infavour of having this all in the title field. Ensure blacklight_solr_conf is deployed after this release is deployed [#1517](https://github.com/ualbertalib/discovery/issues/1517)
- turbolinks to get consistent behaviour of blacklight modals for emailing bookmarks [#1589](https://github.com/ualbertalib/discovery/issues/1589)
- feature flag for RCRF Read on Site and Micro/Newspaper forms [#1605](https://github.com/ualbertalib/discovery/issues/1605)


### Changed
- Created Responsibility field for record view appearing below title [#1544](https://github.com/ualbertalib/discovery/issues/1544)
- made google analytics token configurable through an environment variable (requires new secret) [#1545](https://github.com/ualbertalib/discovery/issues/1545)

### Fixed
- clicking 'more' on the Call Number facet [PR#1593](https://github.com/ualbertalib/discovery/pull/1593)

## [3.0.105] - 2019-04-01

### Fixed
- use safe navigation operator fixes nil error in Symphony Service summary holdings [#1571](https://github.com/ualbertalib/discovery/issues/1571)
- refworks export with encrypted user behavior restored [#1549](https://github.com/ualbertalib/discovery/issues/1549)

### Changed
- Relabelled "Other Physical Details" to "Physical Details" [#1545](https://github.com/ualbertalib/discovery/issues/1545)

### Added
- Added two missing locations in statuses.yml (artists and pop_up) [#1550](https://github.com/ualbertalib/discovery/issues/1550)

## [3.0.104] - 2019-03-27
### Fixed
- Email bookmarks won't return to an 500 error page [PR#1559](https://github.com/ualbertalib/discovery/pull/1559)

## [3.0.103] - 2019-03-20

### Fixed
- A temporary fix to remove refworks export on bookmarks page and recover the bookmark feature [PR#1552](https://github.com/ualbertalib/discovery/pull/1552)

### Changed
- refactor summary_holdings to reflect [change to NodeSet#each in nokogiri](https://github.com/sparklemotion/nokogiri/issues/1822) [PR#1533](https://github.com/ualbertalib/discovery/pull/1533)
- record vcr cassettes for symphony service tests [PR#1533](https://github.com/ualbertalib/discovery/pull/1533)

## [3.0.102] - 2019-03-14

### Security
- Bump rails from 4.2.11 to 4.2.11.1. This update addresses [Two Vulnerabilities in Action View](https://weblog.rubyonrails.org/2019/3/13/Rails-4-2-5-1-5-1-6-2-have-been-released/). [PR#1538](https://github.com/ualbertalib/discovery/pull/1538)

## [3.0.101] - 2019-03-12

### Added
- SOLR_HEAP env var to lightweight docker to avoid Java out of heap error with larger indexes [PR#1536](https://github.com/ualbertalib/discovery/pull/1536)

### Fixed
- pin version of blacklight_range_limit to restore interactive behaviour [PR#1536](https://github.com/ualbertalib/discovery/pull/1536)

## [3.0.100] - 2019-03-08

### Security
- updated to Ruby 2.5.3 [#1432](https://github.com/ualbertalib/discovery/issues/1432)
- updated bootstrap-sass [PR#1528](https://github.com/ualbertalib/discovery/pull/1528)

### Changed
- Ruby and Passenger dependencies in Dockerfile [PR#1531](https://github.com/ualbertalib/discovery/pull/1531)
- minor change to the preamble text in the form from BPSC staff [#1500](https://github.com/ualbertalib/discovery/issues/1500)
- remove BPSC request form feature flag [#1515](https://github.com/ualbertalib/discovery/issues/1515)

### Fixed
- rubocop nags and some deprecation warnings [PR#1528](https://github.com/ualbertalib/discovery/pull/1528)
- Range Facet missing context after following show page link [#1290](https://github.com/ualbertalib/discovery/issues/1290)

### Added
- reintroduced erblint [PR#1528](https://github.com/ualbertalib/discovery/pull/1528)

## [3.0.99] - 2019-02-27

### Removed
-  Subtitles from display [PR#1510](https://github.com/ualbertalib/discovery/pull/1510)

### Fixed
-  pinned the version of bundler used in the Dockerfile [PR#1511](https://github.com/ualbertalib/discovery/pull/1511)


## [3.0.98] - 2019-02-21

### Removed
- ERB-lint prevented the previous release from being deployed expediently because of Ruby 2.1.5 in production. [PR#1507](https://github.com/ualbertalib/discovery/pull/1507)

## [3.0.97] - 2019-02-11

### Removed
- Removed unused partials [#1485](https://github.com/ualbertalib/discovery/pull/1485)

### Added
- Bring in ERB-lint, refactor view code, fix identations, etc [#1486](https://github.com/ualbertalib/discovery/pull/1486)

### Changed
-  Move VCR Fixtures folder to proper place [#1487](https://github.com/ualbertalib/discovery/pull/1487)
-  Added more subfields (t, r, and g) to contents notes [#1121](https://github.com/ualbertalib/discovery/issues/1121)
-  Added more subfields (f, k) to title [#978](https://github.com/ualbertalib/discovery/issues/978)

### Fixed
-  More refactor and html cleanup for discovery [#1492](https://github.com/ualbertalib/discovery/pull/1492)
-  Link to Ask Us page [#1496](https://github.com/ualbertalib/discovery/issues/1496)

## [3.0.96] - 2019-02-07

### Fixed
- Don't show conditions of use unless there is something to show [PR#1479](https://github.com/ualbertalib/discovery/pull/1479)

## [3.0.95] - 2019-01-27

### Added
-   Database license icons [#1333](https://github.com/ualbertalib/discovery/issues/1113)

### Removed 
-   Remove CMS and profiles from the discovery application [PR#1465](https://github.com/ualbertalib/discovery/pull/1465)

### Fixed
-   Fix request forms success flash behaviour by adding flash to CMS layouts [#1443](https://github.com/ualbertalib/discovery/issues/1443)
-   Logic for adding ezproxy to electronic access urls [#1454](https://github.com/ualbertalib/discovery/issues/1454)

## [3.0.94] - 2018-12-19

### Fixed
- Fix NoMethodError in `RecordMailer#sms_record` [#1418](https://github.com/ualbertalib/discovery/issues/1418)
- Quotes in contents field being rendered as &quot; [#1085](https://github.com/ualbertalib/discovery/issues/1085)

### Added
- Add call number to BPSC On Site Request Form [#1417](https://github.com/ualbertalib/discovery/issues/1417)

## [3.0.93] - 2018-12-03
### Added
- Logic for Microform/Newspapers 'Request Me' link [#1217](https://github.com/ualbertalib/discovery/issues/1217)

### Changed
- More electronic access URLs being displayed [#877](https://github.com/ualbertalib/discovery/issues/877)
- Refactored to not use javascript to display electronic access links [PR#1398](https://github.com/ualbertalib/discovery/pull/1398)
- Application Name to 'University of Alberta Libraries' [#1243](https://github.com/ualbertalib/discovery/issues/1243)
- Changed who RCRF read on site request form emails [#1403](https://github.com/ualbertalib/discovery/issues/1403)
- Change application name to Discovery [#1415](https://github.com/ualbertalib/discovery/issues/1415)

### Security
- Bump Rails from 4.2.10 to 4.2.11 [PR#1402](https://github.com/ualbertalib/discovery/pull/1402)

### Fixed
- Fix NoMethodError in email_record mail template [#1408](https://github.com/ualbertalib/discovery/issues/1408)

## [3.0.92] - 2018-11-16

### Fixed
- Corrected location codes for AHS, MacEwan, and King's University [NEOSDiscovery#173](https://github.com/ualbertalib/NEOSDiscovery/issues/173)
- Typo in Usage Rights scholarsportal URL [#1362](https://github.com/ualbertalib/discovery/issues/1362)

### Added
- Mail catcher docker container for checking mail on UAT [#1342](https://github.com/ualbertalib/discovery/pull/1342)
- New request forms for RCRF/BPSC [#1386](https://github.com/ualbertalib/discovery/pull/1386)

### Removed
- Email Interceptor for UAT environments [PR#1387](https://github.com/ualbertalib/discovery/pull/1387)
- Dependency for rubyracer. [#1378](https://github.com/ualbertalib/discovery/issues/1378)

## [3.0.91] - 2018-11-03
### Fixed
- Heavy cleanup of `.rubocop_todo.yml` and refactoring [PR#1359](https://github.com/ualbertalib/discovery/pull/1359)
- Fix test/dev solr cores provisoning for docker [PR#1357](https://github.com/ualbertalib/discovery/pull/1357)
- Refactoring of corrections code [PR#1353](https://github.com/ualbertalib/discovery/pull/1353)
- Fix all files accordingly to new Editorconfig styles [PR#1339](https://github.com/ualbertalib/discovery/pull/1339)

### Added
- Add note about installing java to README.md [PR#1352](https://github.com/ualbertalib/discovery/pull/1352)
- Add Email Interceptor for Staging/UAT environments [PR#1344](https://github.com/ualbertalib/discovery/pull/1344)
- Add Editorconfig to repo for consistent code styling [PR#1338](https://github.com/ualbertalib/discovery/pull/1338)
- Add letter opener gem for testing emails in dev environment [PR#1337](https://github.com/ualbertalib/discovery/pull/1337)
- Logic for 'Request Me' link [#1247](https://github.com/ualbertalib/discovery/issues/1247)

### Removed
- Removed a bunch of files/gems that weren't being used [PR#1345](https://github.com/ualbertalib/discovery/pull/1345)
- Custom bookmark code [PR#1369](https://github.com/ualbertalib/discovery/pull/1369)

### Security
- Bump loofah from 2.2.2 to 2.2.3 [PR#1360](https://github.com/ualbertalib/discovery/pull/1360)

## [3.0.90] - 2018-10-17
### Fixed
- SMS/Email errors [PR#1332](https://github.com/ualbertalib/discovery/pull/1332)

## [3.0.89] - 2018-10-17
### Fixed
- Staff Profile Images [PR#1325](https://github.com/ualbertalib/discovery/pull/1325)

## [3.0.88] - 2018-10-09
### Added
- Rollbar to resolve production errors in minutes (requires new secret) [Issue#1287](https://github.com/ualbertalib/discovery/issues/1287)

### Removed
- Slow code on staff profile page [PR#1319](https://github.com/ualbertalib/discovery/pull/1319)

### Changed
- Fix incorrect libraries listed under 'copies owned' [NEOSDiscovery#152](https://github.com/ualbertalib/NEOSDiscovery/issues/152)

## [3.0.87] - 2018-09-26
### Changed
- Fix diacritics font issues [Issue#1268](https://github.com/ualbertalib/discovery/issues/1268)
- Reword text on Advanced Search page [Issue#1254](https://github.com/ualbertalib/discovery/issues/1254)
- MAP_OS location is not mapped/displays as blank [Issue#1135](https://github.com/ualbertalib/discovery/issues/1135)
- seeing Alberta Health Services - Women's Health in list view as library name for NLC_INT [Issue#1127](https://github.com/ualbertalib/discovery/issues/1127)
- TOC not wrapping around Tools box [Issue#1088](https://github.com/ualbertalib/discovery/issues/1088)
- Remove call number attribute from advanced search [Issue#755] (https://github.com/ualbertalib/discovery/issues/755)
- Make Librarian View a pop-up window [Issue#1242](https://github.com/ualbertalib/discovery/issues/1242)
- changed advanced search text. Fixed CMS login credentials to use secrets.yml

## [3.0.86] - 2018-09-21
### Added
- Github issue templates [PR#1271](https://github.com/ualbertalib/discovery/pull/1271)
- Changelog [PR#1275](https://github.com/ualbertalib/discovery/pull/1275)
- Link to Librarian View [PR#1277](https://github.com/ualbertalib/discovery/pull/1277)

### Removed
- EDS and Article model, view, controllers and tests [#1228](https://github.com/ualbertalib/discovery/issues/1228)

### Changed
- incorrect capitalization of MLA/APA in View Citation link label [PR#1279](https://github.com/ualbertalib/discovery/pull/1279)
- aitfc-fer location code [PR#1266](https://github.com/ualbertalib/discovery/pull/1266)
- the filename for symphony ingest has to be 'big-sample.mrc" because it's hardcoded upstream  [#1261](https://github.com/ualbertalib/discovery/issues/1261)
