# frozen_string_literal: true

require "net/http"
require "json"

module Msci
  module Esg
    # this class will be work with Net
    class Request
      class << self
        def post(path, body, token = nil, retries = 5) # rubocop:disable Metrics/AbcSize
          uri = URI.parse(path)
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true
          https.max_retries = 3

          req = Net::HTTP::Post.new(uri.path)
          req.body = body.compact.to_json
          req["Content-Type"] = "application/json"
          req["Authorization"] = "Bearer #{token}" unless token.nil?

          https.request(req)
        rescue SystemCallError => e
          puts "TRY #{retries} >> ERROR: SystemCallError - #{e}"
          sleep(120)
          raise e if retries <= 1

          post(path, body, token, retries - 1)
        rescue StandardError => e
          puts "TRY #{retries} >> ERROR: StandardError - #{e}"
          sleep(120)
          raise e if retries <= 1

          post(path, body, token, retries - 1)
        end

        def get(path, token = nil, retries = 5)
          uri = URI.parse(path)
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true
          https.max_retries = 3

          req = Net::HTTP::Get.new(uri.to_s)
          req["Content-Type"] = "application/json"
          req["Authorization"] = "Bearer #{token}" unless token.nil?
          https.request(req)
        rescue SystemCallError => e
          puts "TRY #{retries} >> ERROR: SystemCallError - #{e}"
          sleep(120)
          raise e if retries <= 1

          get(path, token, retries - 1)
        rescue StandardError => e
          puts "TRY #{retries} >> ERROR: StandardError - #{e}"
          sleep(120)
          raise e if retries <= 1

          get(path, token, retries - 1)
        end
      end
    end
  end
end
