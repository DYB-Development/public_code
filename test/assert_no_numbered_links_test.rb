require "test_helper"
require "public_code/test_help"

class AssertNoNumberedLinksTest < ActiveSupport::TestCase
  class PageVisitor < ActiveSupport::TestCase
    include PublicCode::TestHelp

    LINKS = { "/home" => [ "/team/members/42", "/team/members/k3f9x2abcdefghijklmnopqr" ], "/settings" => [ "/settings?member_id=7" ] }.freeze

    def get(page) = @page = page

    def links_on_page = LINKS.fetch(@page)
  end

  test "the assertion fails naming each page and each numbered link" do
    failure = assert_raises(Minitest::Assertion) { PageVisitor.new("visit").assert_no_numbered_links([ "/home", "/settings" ]) }

    assert_equal [ "/home links to /team/members/42", "/settings links to /settings?member_id=7" ], failure.message.lines.map(&:strip).last(2)
  end
end
