require 'mastodon_healthchecker/results/network_inspection.rb'

module MastodonHealthchecker
  module AvailabilityInspector
    def self.call(host)
      NetworkInspectionResult.new(v4: inspect_v4, v6: inspect_v6)
    end

    private

    def self.inspect_v4
      # TODO: Implement here
    end

    def self.inspect_v6
      # TODO: Implement here
    end
  end
end
