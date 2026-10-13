---
name: public_code-develop
description: Use PROACTIVELY for declaring a public code on a model, finding a record from a code in a URL, giving a record a new code, and testing that pages link to no numbered addresses — MUST BE USED instead of hand-rolling `to_param` overrides, token columns, `find_by!` lookups on a token column, or regexes over rendered links.
tools: Bash, Read, Write, Edit, Grep
scope: public codes — a random code in a record's addresses in place of its database id, the test that fails on numbered links, and the task that lists which models still use ids
---

This local follows these steps exactly and invents none. Where a step names a
decision, it asks the developer and does not pick.

## What public_code is

A gem that gives an Active Record model a random 24-character code of letters and
digits, used in the model's addresses in place of its database id. Fire this
local when a model should be addressed by code, when a controller loads a record
from an address, when a record's code has to be replaced, or when a test should
fail on any link that exposes an id. Adding the gem and the code column belongs
to **public_code-install**, and that must be done first.

## Interface

- `has_public_code` — declared in a model, optionally with the column name
  (default `:public_code`); gives each new record a code, makes the model's URL
  helpers use the code, and adds the two entry points below.
- `find_by_public_code!` — called on the model with the code from an address;
  returns the record or raises `ActiveRecord::RecordNotFound`.
- `record.regenerate_public_code` — gives a saved record a new code and saves it
  at once; with a custom column the method is `regenerate_<column>`.
- `PublicCode::TestHelp` — a module included in an integration test class after
  `require "public_code/test_help"`.
- `assert_no_numbered_links` — called in that test with a list of page paths;
  visits each one and fails, naming every page and link, when a link or form on
  it points at a numbered address.
- `PublicCode::TestHelp.numbered_links` — takes a list of addresses and returns
  the ones that are numbered, for checking addresses that do not come from a
  page.

## How to use it

1. Confirm the table has its code column. If not, hand off to
   **public_code-install** and come back.

2. Declare the code in the model, with the column name the migration used.

   ```ruby
   class Product < ApplicationRecord
     has_public_code
   end
   ```

   With another column name, pass it: `has_public_code :slug_code`. Declare it
   once per model.

   - A new record gets a code when it is created, or when it is built if the app
     sets `ActiveRecord.generate_secure_token_on = :initialize`. A code already
     set on the record is kept.
   - `product_path(product)`, `url_for(product)`, `redirect_to product` and
     `form_with model: product` now put the code where the id was. Do not
     override `to_param`, and do not pass `product.id` to a route helper.

3. Load the record from the address in each controller action that took an id.

   ```ruby
   def set_product
     @product = Product.find_by_public_code!(params[:id])
   end
   ```

   - Replace every `find(params[:id])`, and every nested `params[:product_id]`
     lookup, for that model.
   - Scope it as the action already scopes its lookups, for example
     `Current.team.products.find_by_public_code!(params[:id])`.
   - It raises `ActiveRecord::RecordNotFound`, so a missing code is a 404 as
     before. Once the column exists, an id in the address is not found.
   - Do not change the route parameter name. It stays `:id`.

4. Give a record a new code only where the developer asks for one, for example
   after a code was shared by mistake. Ask the developer whether the old address
   should stop working, since it does.

   ```ruby
   product.regenerate_public_code
   ```

   It raises when the record is invalid. Redirect to the record's new address
   afterwards.

5. Add an integration test that fails on numbered links.

   ```ruby
   require "test_helper"
   require "public_code/test_help"

   class ProductAddressesTest < ActionDispatch::IntegrationTest
     include PublicCode::TestHelp

     test "no product page links to a numbered address" do
       product = products(:one)
       assert_no_numbered_links([ "/products", "/products/#{product.public_code}" ], safe: [ "page" ])
     end
   end
   ```

   - Ask the developer which pages to list. Each must render for the test as
     written, so sign in first in the test if the pages need it.
   - Ask the developer which query parameters hold a number that is not an id,
     such as `page` or `per`, and pass those names in `safe:`.
   - It checks every `a[href]` and `form[action]`. An address counts as numbered
     when any path segment is all digits, or any query value is all digits and its
     name is not in `safe:`.
   - Addresses that do not start with `/`, start with `//`, `/assets/` or
     `/rails/active_storage/` are not checked.

6. For addresses built outside a page, such as in a mailer or a JSON response,
   check them directly.

   ```ruby
   assert_empty PublicCode::TestHelp.numbered_links([ product_path(product) ], safe: [ "page" ])
   ```

7. Run the tests. A failure names each page and the link on it that still uses an
   id. Fix the link by passing the record, not its id, to the route helper.

## Conventions

- Always declare the code with the same column name the migration created.
- Always look up an addressed record with `find_by_public_code!`, never with
  `find` or `find_by!(id:)`.
- Never put a record's `id` in a link, form action or redirect.
- Never write a code by hand. Codes come from the gem.
- Before the table has its column, the model stays addressed and found by id.
  That is expected while a migration is pending, and is not a bug to fix here.
- `assert_no_numbered_links` works only in a test that can make requests and read
  the response, such as `ActionDispatch::IntegrationTest`.
- Out of scope here: adding the gem, the migration that adds and fills the code
  column, and checking which models are still addressed by id. Those are
  **public_code-install**'s.
