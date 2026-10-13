---
name: public_code-info
description: Use to learn what public_code offers — a random code in a record's addresses in place of its database id, the test that fails on numbered links, and the task that lists which models still use ids.
tools: Read
scope: public codes — a random code in a record's addresses in place of its database id, the test that fails on numbered links, and the task that lists which models still use ids
---

This local explains what public_code is and the words it uses. It makes no
changes and gives no steps.

## What public_code is

public_code gives an Active Record model a random code that stands in for its
database id wherever a person or an outside caller sees the record: page
addresses, API and MCP addresses, and links sent out. Every address Rails builds
for the record carries the code, and the record is found from that code, so no
address shows an id and no one can step through records by counting.

Reach for it when an app or a gem exposes records at addresses and the ids in
those addresses should not be visible or guessable. It also gives an
integration test that fails when a page still links to a numbered address, and a
task that reports which models are still addressed by id.

## Interface

This local documents no commands. Two other locals own the whole surface:

- **public_code-install** owns adding the gem to an app or gem, generating codes
  for existing records in a migration, and the task that reports which models
  are addressed by code or by id.
- **public_code-develop** owns declaring a code on a model, finding a record from
  the code in an address, giving a record a new code, and the integration test
  helper that checks pages for numbered links.

## How to use it

- To add public_code to an app or gem, or to check across an app which models
  still use ids, go to **public_code-install**.
- To give a model a code, look records up by code, or test that pages carry no
  numbered links, go to **public_code-develop**.

## Conventions

- **Code** — a random string of 24 letters and digits, stored in its own column
  with a unique index. The column is named after the gem by default, and a model
  may name its own.
- **Address** — any path or link a person or outside caller sees. Codes are for
  addresses only.
- **Id** — the database id. It stays the internal key records point at each
  other with, and it never changes.
- **Addressed by code / addressed by id** — whether a model's table has its code
  column yet. A model that declares a code but whose table has no column is still
  addressed and found by id, so a gem can declare codes before every app that
  uses it has migrated. Once the column exists, an all-digit address is not
  found.
- **Not found** — a lookup by code raises the standard Active Record not-found
  error when no record among those searched has that code, so a lookup limited
  to one client's records never finds another client's.
- **Numbered link** — a link or form on one of the app's own pages whose path has
  an all-digit segment, or whose query has an all-digit value. Links to other
  sites, asset files and stored files are never counted.
- **Safe query names** — query parameter names, such as a page number, whose
  all-digit values are allowed and not counted as numbered links.
- **Strict mode** — the status report run so that it fails, naming each model
  still addressed by id, for a deploy or CI step that requires every migration to
  have run.
