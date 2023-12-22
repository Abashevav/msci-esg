# frozen_string_literal: true

require "net/http"
require "json"

module Msci
  module Esg
    class AuthError < RuntimeError; end

    # this class will be work with ESG Data API v2
    class DataAPI
      API_VERSION = "/v2"
      BASE_PATH = "https://api.msci.com/esg/report"

      def initialize(client_id, secret_key)
        @client_id = client_id
        @secret_key = secret_key

        @token = nil
      end

      def self.execute(function)
        res = get(BASE_PATH + API_VERSION + function)
        puts res.body
        true
      end

      def auth
        res = post(
          "https://accounts.msci.com/oauth/token",
          {
            "client_id" => @client_id,
            "client_secret" => @secret_key,
            "grant_type" => "client_credentials",
            "audience" => "https://esg/report"
          }
        )
        puts res.body

        response = JSON.parse(res.body)
        return response["error_description"] if response["error"]

        true
      end

      private

      def post(uri, body)
        uri = URI.parse(uri)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        req = Net::HTTP::Post.new(uri.path)
        req.body = body.to_json
        req["Content-Type"] = "application/json"

        https.request(req)
      end

      def get(uri)
        uri = URI.parse(uri)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        req = Net::HTTP::Get.new(uri.path)
        req["Content-Type"] = "application/json"
        req["Authorization"] = "Bearer #{@token}"
        http.request(req)
      end
    end
  end
end
