# frozen_string_literal: true

##
# Copyright (C) 2017 nullkal.
#
# This program is a derived work from Resolv::Hosts of Ruby 2.4
# (https://github.com/ruby/ruby/).
#
# ----
#
# Copyright (C) 1993-2013 Yukihiro Matsumoto. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#

require 'resolv'

module MastodonHealthchecker
  class HashHosts
    def initialize(hosts)
      @name2addr = hosts

      @addr2name = {}
      hosts.each do |name, addrs|
        addrs.each do |addr|
          @addr2name[addr] ||= []
          @addr2name[addr] << name
        end
      end
    end

    ##
    # Gets the IP address of +name+ from the hosts file.

    def getaddress(name)
      each_address(name) {|address| return address}
      raise ResolvError.new("#{@filename} has no name: #{name}")
    end

    ##
    # Gets all IP addresses for +name+ from the hosts file.

    def getaddresses(name)
      ret = []
      each_address(name) {|address| ret << address}
      return ret
    end

    ##
    # Iterates over all IP addresses for +name+ retrieved from the hosts file.

    def each_address(name, &proc)
      if @name2addr.include?(name)
        @name2addr[name].each(&proc)
      end
    end

    ##
    # Gets the hostname of +address+ from the hosts file.

    def getname(address)
      each_name(address) {|name| return name}
      raise ResolvError.new("#{@filename} has no address: #{address}")
    end

    ##
    # Gets all hostnames for +address+ from the hosts file.

    def getnames(address)
      ret = []
      each_name(address) {|name| ret << name}
      return ret
    end

    ##
    # Iterates over all hostnames for +address+ retrieved from the hosts file.

    def each_name(address, &proc)
      @addr2name[address]&.each(&proc)
    end
  end
end
