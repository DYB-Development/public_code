# public_code

Gives an Active Record model a random code that its addresses carry and that
finds it, so no address shows a database id. The database id stays the
internal key that records point at each other with.

## Install

```ruby
gem "public_code"
```

## Use

Add a code column with a unique index, and fill it for records that already exist:

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

Name the code on the model:

```ruby
class Product < ApplicationRecord
  has_public_code
end
```

A new product gets a random 24 character code of letters and digits. Every
address Rails builds for it carries the code in place of its id, so
`product_path(product)` is `/products/k3f9x2…`.

Find a record from the code in an address:

```ruby
Product.find_by_public_code!(params[:id])
current_client.products.find_by_public_code!(params[:id])
```

It raises `ActiveRecord::RecordNotFound` when no record among those searched
has that code, so a search limited to one client's records never finds
another client's.

A column with its own name works the same way:

```ruby
has_public_code :code
```

## Codes are for addresses only

A code replaces the id only where a person or an outside caller sees it: page
addresses, API and MCP addresses, and links sent out. Records still point at
each other by id, and a record's id never changes.

## A gem whose records take codes in some apps first

A gem declares the code on its model the same way:

```ruby
module EasyFlow
  class Run < ApplicationRecord
    has_public_code
  end
end
```

Until an app's table has the code column, a record is addressed and found by
its id exactly as before, so a gem can release this without every app
migrating at once. Once the table has the column, every address carries the
code and an all-digit address is not found. Ship the migration that adds the
column with the gem and name it in the gem's changelog.

An app switches a gem's records to codes by copying and running that migration,
then restarting so the new column is seen.

## Checking pages for numbered links

In an integration test:

```ruby
require "public_code/test_help"

class ClientAddressesTest < ActionDispatch::IntegrationTest
  include PublicCode::TestHelp

  test "no client page links to a numbered address" do
    assert_no_numbered_links([ "/home", "/products/#{product.public_code}" ], safe: [ "page" ])
  end
end
```

It fails when a link or form on any page has an all-digit path segment, or an
all-digit query value whose name is not in `safe:`, and names each page and
link. Links to other sites, asset files and stored files are not checked.
