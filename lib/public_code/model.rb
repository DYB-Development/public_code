module PublicCode
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def has_public_code(column = :public_code)
        has_secure_token column, length: PublicCode::LENGTH
      end
    end
  end
end
