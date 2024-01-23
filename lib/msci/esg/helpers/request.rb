# frozen_string_literal: true

require "net/http"
require "json"

module Msci
  module Esg
    # this class will be work with Net
    class Request
      class << self
        def post(uri, body, token = nil)
          uri = URI.parse(uri)
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true

          req = Net::HTTP::Post.new(uri.path)
          req.body = body.compact.to_json
          req["Content-Type"] = "application/json"
          req["Authorization"] = "Bearer #{token}" unless token.nil?

          https.request(req)
        end

        def get(uri, token = nil)
          uri = URI.parse(uri)
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true

          req = Net::HTTP::Get.new(uri.to_s)
          req["Content-Type"] = "application/json"
          req["Authorization"] = "Bearer #{token}" unless token.nil?
          https.request(req)
        end
      end
    end
  end
end
