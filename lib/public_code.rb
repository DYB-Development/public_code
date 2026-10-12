require "active_record"
require "active_support"
require "public_code/version"
require "public_code/model"

module PublicCode
  LENGTH = 24
end

ActiveSupport.on_load(:active_record) { include PublicCode::Model }
