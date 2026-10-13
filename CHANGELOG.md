# Changelog

## [Unreleased]

## [0.3.0] - 2026-10-12

### Added

- `bin/rails public_code:status` lists every model that declares a code and whether it is addressed by code or by id.
- With `STRICT=1` the status task fails naming each model still addressed by id.

## [0.2.0] - 2026-10-12

### Added

- A record whose table has no code column yet is addressed and found by its id, so a gem can give its records codes before every app has migrated.
- A record whose table has the code column is not found by an all-digit address.
- `assert_no_numbered_links` fails a test naming each page that links to an address with an all-digit path segment or query value.

### Changed

- A record gets its code when the app's secure token setting says, as with Rails' own secure tokens.

## [0.1.0]

### Added

- A model that calls `has_public_code` gives each new record a random 24 character code, and every address Rails builds for the record carries that code in place of its id.
- `find_by_public_code!` finds a record by its code among the records searched, whatever the code column is named.
- `PublicCode.generate` makes a code for a record that already exists, such as in a migration.
