require "test_helper"

class Flow < ActiveRecord::Base
  has_public_code
end

class CodeOrIdTest < ActiveSupport::TestCase
  test "a record whose table has no code column yet is addressed by its id" do
    flow = Flow.create!(name: "Site visit")

    assert_equal flow.id.to_s, flow.to_param
  end

  test "a record whose table has no code column yet is found by the id in its address" do
    flow = Flow.create!(name: "Site visit")

    assert_equal flow, Flow.find_by_public_code!(flow.to_param)
  end
end
