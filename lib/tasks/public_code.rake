namespace :public_code do
  desc "List each model that declares a code and whether it is addressed by code or by id, failing on any by id when STRICT=1"
  task status: :environment do
    Rails.application.eager_load! if defined?(Rails.application) && Rails.application
    models = PublicCode.models.sort_by(&:name)
    models.each { |model| puts "#{model.name} addressed by #{model.public_code_column? ? "code" : "id"}" }

    by_id = models.reject(&:public_code_column?)
    abort "Still addressed by id: #{by_id.map(&:name).join(", ")}" if ENV["STRICT"] == "1" && by_id.any?
  end
end
