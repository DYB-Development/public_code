require "minitest/autorun"
require "public_code"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :products do |t|
    t.string :name
    t.string :public_code
    t.index :public_code, unique: true
  end

  create_table :flows do |t|
    t.string :name
  end

  create_table :reports do |t|
    t.string :name
    t.string :code
    t.index :code, unique: true
  end
end

class ActiveSupport::TestCase
  self.use_transactional_tests = true if respond_to?(:use_transactional_tests=)
end
