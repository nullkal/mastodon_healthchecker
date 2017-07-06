require 'faraday'
require 'faraday_middleware'
require 'faraday/encoding'
require 'json'
require 'mastodon_healthchecker/hash_hosts'
require 'nokogiri'
require 'resolv'
require 'resolv-replace'

module MastodonHealthchecker
  class InstanceInfo

    class << self
      def fetch(host, addresses)
        default_resolver = Resolv::DefaultResolver

        hash_hosts = HashHosts.new({ "#{host}" => addresses })
        Resolv::DefaultResolver.replace_resolvers([hash_hosts])

        begin
          info = InstanceInfo.new
          info.parse_about(get(host, '/about'))
          info.parse_about_more(get(host, '/about/more'))
          info.parse_instance(get(host, '/api/v1/instance'))
          info
        rescue Faraday::ClientError, Nokogiri::SyntaxError, JSON::ParseError
          nil
        ensure
          Resolv::DefaultResolver.replace_resolvers(default_resolver)
        end
      end

      private

      def get(host, path)
        conn = Faraday.new("http://#{host}") do |faraday|
          faraday.use FaradayMiddleware::FollowRedirects
          faraday.response :encoding
          faraday.response :raise_error
          faraday.adapter :net_http
        end
        conn.get(path)
      end
    end

    def initialize
      @version = nil

      @users = nil
      @statuses = nil
      @connections = nil

      @description = nil
      @extended_description = nil
      @email = nil

      @opened = nil
      @https_configured = nil
    end

    def parse_about(response)
      doc = Nokogiri::HTML.parse(response.body)
      @opened = doc.xpath("//*[@class='closed-registrations-message']").empty?
      @https_configured = response.to_hash[:url].to_s.start_with?('https://')
    end

    def parse_about_more(response)
      doc = Nokogiri::HTML.parse(response.body)

      info = doc.xpath("//*[@class='main']/*[@class='information-board']/*[@class='section']/strong")
      if 3 <= info.length
        @users = info[0].text.tr(',', '').to_i
        @statuses = info[1].text.tr(',', '').to_i
        @connections = info[2].text.tr(',', '').to_i
      end

      @extended_description = doc.xpath("//*[@class='main']/*[@class='panel'][2]").inner_html
    end

    def parse_instance(response)
      instance = JSON.parse(response.body)
      @version = instance['version']
      @description = instance['description']
      @email = instance['email'] unless instance['email'].empty?
    end

    attr_reader :version, :users, :statuses, :connections,
                :description, :extended_description, :email, :opened
  end
end
