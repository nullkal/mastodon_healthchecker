module MastodonHealthchecker
  module RecordExistenceInspector
    class Result
      def initialize(v4: false, v6: false)
        @v4 = v4
        @v6 = v6
      end

      attr_accessor :v4, :v6
    end

    def self.call(host)
      Result.new(v4: inspect_v4, v6: inspect_v6)
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
