namespace :public_code do
  desc "List each model that declares a code and whether it is addressed by code or by id"
  task status: :environment do
    Rails.application.eager_load! if defined?(Rails.application) && Rails.application
    PublicCode.models.sort_by(&:name).each do |model|
      puts "#{model.name} addressed by #{model.public_code_column? ? "code" : "id"}"
    end
  end
end
