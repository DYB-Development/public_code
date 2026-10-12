require "uri"

module PublicCode
  module TestHelp
    def self.numbered_links(addresses, safe: [])
      addresses.select do |address|
        next false unless own_page?(address)

        uri = URI(address)
        numbered_path?(uri.path) || numbered_query?(uri.query, safe)
      end
    end

    def self.own_page?(address) = address.start_with?("/") && !address.start_with?("//", "/assets/", "/rails/active_storage/")

    def self.numbered_path?(path) = path.split("/").any? { |segment| number?(segment) }

    def self.numbered_query?(query, safe) = URI.decode_www_form(query.to_s).any? { |name, value| !safe.include?(name) && number?(value) }

    def self.number?(value) = value.match?(/\A\d+\z/)
  end
end
