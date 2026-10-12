require "test_helper"
require "public_code/test_help"

class NumberedLinksTest < ActiveSupport::TestCase
  test "an address with an all-digit path segment is a numbered link" do
    assert_equal [ "/team/members/42" ], PublicCode::TestHelp.numbered_links([ "/team/members/42", "/team/members/k3f9x2abcdefghijklmnopqr" ])
  end

  test "an address with an all-digit query value is a numbered link unless its name is marked safe" do
    assert_equal [ "/settings?member_id=42" ], PublicCode::TestHelp.numbered_links([ "/settings?member_id=42", "/products?page=2" ], safe: [ "page" ])
  end

  test "links to other sites, asset files and stored files are not numbered links" do
    addresses = [ "https://example.com/posts/42", "//cdn.example.com/42", "/assets/icons/2026.svg", "/rails/active_storage/blobs/redirect/2026/guide.pdf" ]

    assert_empty PublicCode::TestHelp.numbered_links(addresses)
  end
end
