# Changelog

## [Unreleased]

### Added

- A model that calls `has_public_code` gives each new record a random 24 character code, and every address Rails builds for the record carries that code in place of its id.
- `find_by_public_code!` finds a record by its code among the records searched, whatever the code column is named.
- `PublicCode.generate` makes a code for a record that already exists, such as in a migration.
