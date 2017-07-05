require 'mastodon_healthchecker/dns_records'
require 'mastodon_healthchecker/instance_info'
require 'mastodon_healthchecker/version'

module MastodonHealthchecker
  Result = Struct.new('Result', :exists_record, :up, :info)

  def self.perform(host)
    records = DNSRecords.new(host)
    info_v4 = InstanceInfo.fetch(host, records.v4_addresses)
    info_v6 = InstanceInfo.fetch(host, records.v6_addresses)

    Result.new(
      { v4: records.v4_addresses.any?, v6: records.v6_addresses.any? },
      { v4: !info_v4.nil?, v6: !info_v6.nil? },
      info_v4 || info_v6 || nil
    )
  end
end
