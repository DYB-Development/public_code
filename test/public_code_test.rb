require "test_helper"

class Product < ActiveRecord::Base
  has_public_code
end

class PublicCodeTest < ActiveSupport::TestCase
  test "a new record is given a random 24 character code" do
    assert_match(/\A[a-zA-Z0-9]{24}\z/, Product.create!(name: "Field guide").public_code)
  end
end
