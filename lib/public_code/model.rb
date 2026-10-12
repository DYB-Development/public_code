module PublicCode
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def has_public_code(column = :public_code)
        has_secure_token column, length: PublicCode::LENGTH
        define_method(:to_param) { public_send(column) }
        define_singleton_method(:find_by_public_code!) { |code| find_by!(column => code) }
      end
    end
  end
end
