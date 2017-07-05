module MastodonHealthchecker
  class NetworkInspectionResult
    def initialize(v4: false, v6: false)
      @v4 = v4
      @v6 = v6
    end

    def to_s
      "v4: #{v4}, v6: #{v6}"
    end

    attr_accessor :v4, :v6
  end
end

