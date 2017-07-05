module MastodonHealthchecker
  class NetworkInspectionResult
    def initialize(options = {})
      @v4 = options[:v4]
      @v6 = options[:v6]
    end

    def to_s
      "v4: #{v4}, v6: #{v6}"
    end

    attr_accessor :v4, :v6
  end
end

