---
name: New Release
about: Things to remember when cutting a new release.

---

Things to think about:
- [ ] Does this require a reindex?
- [ ] Are there any db migrations?
- [ ] Are there configuration changes?
- [ ] Are all changes recorded in the CHANGELOG?
- [ ] Are all changes backward compatible? (No? - Major)
- [ ] Does the change add new features? (Yes? - Minor)
- [ ] Does the change only add bug fixes? (Yes? - Patch)
- [ ] Does this release address any security concerns?
- [ ] Does this release require any changes to documented procedures?

Things you must do:
- [ ] bump VERSION https://github.com/ualbertalib/discovery/blob/99bd93bf6bd699ba88493eedf5ccc645d999a1b7/config/application.rb#L11
- [ ] bump CHANGELOG https://github.com/ualbertalib/discovery/blob/master/CHANGELOG.md#unreleased
- [ ] create the release tag in this form: "v1.2.3". Follow [semantic tagging](http://semver.org/) principles.
- [ ] add release notes
- [ ] email UNIX team responsible for service deployment and cc relevant groups

For more information see the [Developer Handbook](https://github.com/ualbertalib/Developer-Handbook/blob/master/Github/README.md#checklist-for-cutting-a-release) and [Release Management](https://github.com/ualbertalib/di_internal/blob/master/System-Adminstration/Release-Management.md#release-managment)
