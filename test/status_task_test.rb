require "test_helper"
require "rake"

class StatusCoded < ActiveRecord::Base
  self.table_name = "products"
  has_public_code
end

class StatusUncoded < ActiveRecord::Base
  self.table_name = "flows"
  has_public_code
end

class StatusTaskTest < ActiveSupport::TestCase
  setup do
    Rake.application = Rake::Application.new
    Rake::Task.define_task(:environment)
    load File.expand_path("../lib/tasks/public_code.rake", __dir__)
  end

  teardown { ENV.delete("STRICT") }

  def run_status
    capture_io { Rake::Task["public_code:status"].invoke }.first
  end

  test "the status task lists each model that declares a code and whether it is addressed by code or id" do
    assert_equal [ "StatusCoded addressed by code", "StatusUncoded addressed by id" ], run_status.lines.map(&:chomp).grep(/\AStatus/)
  end

  test "in strict mode the status task fails naming each model still addressed by id" do
    ENV["STRICT"] = "1"

    assert_match(/StatusUncoded/, assert_raises(SystemExit) { run_status }.message)
  end
end
