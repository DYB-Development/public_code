module PublicCode
  class Railtie < Rails::Railtie
    rake_tasks { load File.expand_path("../tasks/public_code.rake", __dir__) }
  end
end
