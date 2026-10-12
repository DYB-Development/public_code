require "active_record"
require "active_support"
require "public_code/version"
require "public_code/model"

module PublicCode
  LENGTH = 24

  def self.generate = ActiveRecord::Base.generate_unique_secure_token(length: LENGTH)
end

ActiveSupport.on_load(:active_record) { include PublicCode::Model }
