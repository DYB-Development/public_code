require "test_helper"
require "public_code/test_help"

class NumberedLinksTest < ActiveSupport::TestCase
  test "an address with an all-digit path segment is a numbered link" do
    assert_equal [ "/team/members/42" ], PublicCode::TestHelp.numbered_links([ "/team/members/42", "/team/members/k3f9x2abcdefghijklmnopqr" ])
  end
end
