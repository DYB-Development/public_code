require_relative "lib/public_code/version"

Gem::Specification.new do |spec|
  spec.name = "public_code"
  spec.version = PublicCode::VERSION
  spec.authors = [ "Tyler Schneider" ]
  spec.email = [ "tylercschneider@gmail.com" ]
  spec.homepage = "https://github.com/DYB-Development/public_code"
  spec.summary = "A random code for a record's addresses in place of its database id."
  spec.description = "Gives an Active Record model a random code that its addresses carry and that finds it, so no address shows a database id."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["documentation_uri"] = "#{spec.homepage}#readme"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.required_ruby_version = ">= 3.3.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["lib/**/*", "the_local/**/*", "LICENSE", "README.md", "CHANGELOG.md"]
  end

  spec.add_dependency "activerecord", ">= 7.1"
  spec.add_dependency "activesupport", ">= 7.1"
end
