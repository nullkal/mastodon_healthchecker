require 'mastodon_healthchecker/results/network_inspection.rb'
require 'resolv'

module MastodonHealthchecker
  module RecordExistenceInspector
    def self.call(host)
      exists_v4addr = false
      exists_v6addr = false
      Resolv::DNS.new.each_address(host) do |addr|
        case addr
        when Resolv::IPv4
          exists_v4addr = true
        when Resolv::IPv6
          exists_v6addr = true
        else
          raise "Resolver returns an address which is neither IPv4 nor IPv6."
        end
      end
      NetworkInspectionResult.new(v4: exists_v4addr, v6: exists_v6addr)
    end
  end
end
