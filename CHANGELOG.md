# Changelog
All notable changes to Discovery project will be documented in this file. Discovery is the University of Alberta Libraries' catalogue interface, built using Blacklight: http://projectblacklight.org/. https://library.ualberta.ca/.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and releases in Discovery project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- More electronic access URLs being displayed [#877](https://github.com/ualbertalib/discovery/issues/877)
- Refactored to not use javascript to display electronic access links [PR#1398](https://github.com/ualbertalib/discovery/pull/1398)

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
