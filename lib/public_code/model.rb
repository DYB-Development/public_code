module PublicCode
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def has_public_code(column = :public_code)
        define_singleton_method(:public_code_column?) { table_exists? && column_names.include?(column.to_s) }
        define_method(:give_public_code) { self[column] ||= PublicCode.generate if self.class.public_code_column? }
        define_method(:"regenerate_#{column}") { update!(column => PublicCode.generate) }
        after_initialize :give_public_code, if: :new_record?
        before_create :give_public_code
        define_method(:to_param) { self.class.public_code_column? ? public_send(column) : super() }
        define_singleton_method(:find_by_public_code!) { |address| public_code_column? ? find_by!(column => address) : find(address) }
      end
    end
  end
end
