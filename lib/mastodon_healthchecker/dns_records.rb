require 'resolv'

module MastodonHealthchecker
  class DNSRecords
    def initialize(host)
      @v4_addresses = []
      @v6_addresses = []
      Resolv::DNS.new.each_address(host) do |addr|
        case addr
        when Resolv::IPv4
          v4_addresses << addr
        when Resolv::IPv6
          v6_addresses << addr
        else
          raise "Resolver returns an address which is neither IPv4 nor IPv6."
        end
      end
    end

    attr_reader :v4_addresses, :v6_addresses
  end
end

