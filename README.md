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
