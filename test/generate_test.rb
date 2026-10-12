require "test_helper"

class GenerateTest < ActiveSupport::TestCase
  test "a code can be made for an existing record, such as in a migration" do
    assert_match(/\A[a-zA-Z0-9]{24}\z/, PublicCode.generate)
  end
end
