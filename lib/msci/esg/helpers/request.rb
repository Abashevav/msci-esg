# frozen_string_literal: true

require "net/http"
require "json"

module Msci
  module Esg
    # this class will be work with Net
    class Request
      class << self
        def post(uri, body, token = nil, retries = 5)
          uri = URI.parse(uri)
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true
          https.max_retries = 3

          req = Net::HTTP::Post.new(uri.path)
          req.body = body.compact.to_json
          req["Content-Type"] = "application/json"
          req["Authorization"] = "Bearer #{token}" unless token.nil?

          https.request(req)
        rescue Net::OpenTimeout => e
          puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
          sleep(60)
          raise e if retries <= 1

          post(uri, body, token, retries - 1)
        end

        def get(uri, token = nil, retries = 5)
          uri = URI.parse(uri)
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true
          https.max_retries = 3

          req = Net::HTTP::Get.new(uri.to_s)
          req["Content-Type"] = "application/json"
          req["Authorization"] = "Bearer #{token}" unless token.nil?
          https.request(req)
        rescue Net::OpenTimeout => e
          puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
          sleep(60)
          raise e if retries <= 1

          get(uri, token, retries - 1)
        end
      end
    end
  end
end
