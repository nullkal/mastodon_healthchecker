require 'mastodon_healthchecker/hash_hosts'
require 'nokogiri'
require 'faraday'
require 'faraday_middleware'
require 'faraday/encoding'
require 'resolv'
require 'resolv-replace'

module MastodonHealthchecker
  class InstanceInfo
    def self.fetch(host, addresses)
      default_resolver = Resolv::DefaultResolver

      hash_hosts = HashHosts.new({ "#{host}" => addresses })
      Resolv::DefaultResolver.replace_resolvers([hash_hosts, Resolv::DNS.new])

      result = nil
      begin
        conn = Faraday.new("http://#{host}") do |faraday|
          faraday.use FaradayMiddleware::FollowRedirects
          faraday.response :encoding
          faraday.response :raise_error
          faraday.adapter :net_http
        end

        info = InstanceInfo.new
        info.parse_about(conn.get('/about'))
        info.parse_about_more(conn.get('/about/more'))
        info.parse_instance(conn.get('/api/v1/instance'))
        result = info
      rescue Faraday::ClientError
      rescue Nokogiri::SyntaxError
      end

      Resolv::DefaultResolver.replace_resolvers(default_resolver)
      result
    end

    def initialize
      @version = nil

      @users = nil
      @statuses = nil
      @connections = nil

      @description = nil
      @extended_description = nil
      @opened = nil
    end

    def parse_about(response)
      # TODO: Implement here
    end

    def parse_about_more(response)
      # TODO: Implement here
    end

    def parse_instance(response)
      # TODO: Implement here
    end

    attr_reader :version, :users, :statuses, :connections,
                :description, :extended_description, :opened
  end
end
