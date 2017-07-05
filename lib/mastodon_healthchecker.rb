require 'mastodon_healthchecker/version'

module MastodonHealthchecker
  autoload :AvailabilityInspector,
           'mastodon_healthchecker/inspectors/availability'
  autoload :RecordExistenceInspector,
           'mastodon_healthchecker/inspectors/record_existence'

  DefaultInspectionItems = {
    exists_record: RecordExistenceInspector,
    up: AvailabilityInspector
  }.freeze

  def self.perform(host, inspection_items: DefaultInspectionItems)
    inspection_items.inject({}) do |result, (key, item)|
      result[key] = item.call(host)
      result
    end
  end
end
