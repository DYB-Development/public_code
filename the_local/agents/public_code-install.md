---
name: public_code-install
description: Use to hook public_code into a project — adding the gem, a migration that adds the code column and fills it with `PublicCode.generate`, and checking with `bin/rails public_code:status` which models are addressed by code or by id.
tools: Bash, Read, Edit
scope: public codes — a random code in a record's addresses in place of its database id, the test that fails on numbered links, and the task that lists which models still use ids
---

This local follows these steps exactly and invents none. Where a step names a
decision, it asks the developer and does not pick.

## What public_code is

A gem that gives an Active Record model a random 24-character code of letters and
digits to use in its addresses in place of its database id; hook it into a Rails
app or a gem whose records are shown at addresses where ids should not be seen.

## Interface

- `gem "public_code"` — the Gemfile line, or a runtime dependency in a gem's
  gemspec, that adds the gem; it needs Ruby 3.3 or later and Active Record 7.1 or
  later, and loads itself into Active Record with no initializer.
- `PublicCode.generate` — returns a new random 24-character code; a migration
  calls it to fill the code column for records that already exist.
- `bin/rails public_code:status` — lists every model that declares a code and
  whether it is addressed by code or by id; with `STRICT=1` it exits non-zero and
  names each model still addressed by id.

## How to use it

1. Ask the developer whether the host is a Rails app or a gem whose models other
   apps use. The steps differ at step 4.

2. Add the gem.
   - Rails app: add `gem "public_code"` to `Gemfile`, then run `bundle install`.
     `Gemfile.lock` changes.
   - Gem: add `spec.add_dependency "public_code"` to the host's `*.gemspec`, then
     run `bundle install`. Ask the developer which version constraint to use.

3. Ask the developer which tables get a code, and for each one whether the column
   is named `public_code` (the default) or another name. The column name chosen
   here must match the name given when the model declares its code.

4. Write one migration per table. In a Rails app, create it with
   `bin/rails generate migration AddPublicCodeTo<Models>` and fill it in as below.
   In a gem, put the migration in the gem's own migrations directory, so each app
   copies and runs it later, and name it in the gem's changelog.

   ```ruby
   class AddPublicCodeToProducts < ActiveRecord::Migration[8.1]
     class Product < ActiveRecord::Base
       self.table_name = "products"
     end

     def up
       add_column :products, :public_code, :string
       Product.find_each { |product| product.update_columns(public_code: PublicCode.generate) }
       change_column_null :products, :public_code, false
       add_index :products, :public_code, unique: true
     end

     def down
       remove_column :products, :public_code
     end
   end
   ```

   - Replace `products`, `Product` and `public_code` with the table, a class name
     for it, and the column name from step 3.
   - Keep the class defined inside the migration. It reads and writes the table
     without the app model's callbacks.
   - Set the `Migration[...]` version to the host's Rails version.

5. Declare the code on each model. That step and everything after it, finding
   records by code and testing pages for numbered links, belongs to
   **public_code-develop**. Hand off to it here.

6. In a Rails app, run `bin/rails db:migrate`. `db/schema.rb` (or
   `db/structure.sql`) changes. Restart any running server or console, since a
   process started before the migration still treats the table as having no code
   column.

7. In a Rails app, run `bin/rails public_code:status` and confirm every model from
   step 3 prints `addressed by code`.

8. Ask the developer whether a deploy or CI step should require every model to be
   addressed by code. If yes, add `STRICT=1 bin/rails public_code:status` to that
   step, after migrations run.

## Conventions

- `public_code:status` exists only in a Rails app. A gem host does not run it
  itself; each app that uses the gem does.
- The task only lists models that already declare a code. A table with a code
  column whose model declares none does not appear.
- A model that declares a code before its table has the column keeps being
  addressed and found by id. That is how a gem can release codes before every app
  has migrated, and why step 7 is the check that the switch happened.
- When an app upgrades a gem that has added a code migration, copy that migration
  into the app, run it, restart, and rerun step 7.
- Out of scope here: declaring the code on a model, finding a record by code,
  giving a record a new code, and the numbered-link test helper. Those are
  **public_code-develop**'s.
