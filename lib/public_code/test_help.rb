require "uri"

module PublicCode
  module TestHelp
    def self.numbered_links(addresses)
      addresses.select { |address| URI(address).path.split("/").any? { |segment| segment.match?(/\A\d+\z/) } }
    end
  end
end
