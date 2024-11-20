# frozen_string_literal: true

require "json"
require "cgi"
require "date"

module Msci
  # this module will be work with all MSCI ESG solution
  module Esg
    class AuthError < RuntimeError; end

    # parent class
    class BaseAPI
      AUTH_PATH = "https://accounts.msci.com/oauth/token"
      attr_accessor :token, :audience, :expires_in, :token_type, :client_id, :secret_key
      attr_accessor :last_request_paging, :last_request_messages, :last_request_status, :last_request_code, :last_request_trace_id

      def initialize(client_id, secret_key)
        @client_id = client_id
        @secret_key = secret_key
        @audience = "https://esg/data"
      end

      def auth
        res = Msci::Esg::Request.post(
          AUTH_PATH,
          {
            "client_id" => @client_id,
            "client_secret" => @secret_key,
            "grant_type" => "client_credentials",
            "audience" => @audience,
          }
        )
        response = JSON.parse(res.body)
        return response["error_description"] if response["error"]

        if response["access_token"]
          @token = response["access_token"]
          @expires_in = DateTime.now + Rational(response["expires_in"].to_i, 86_400)
          @token_type = response["token_type"]
        end

        true
      end

      def get_result(request) # rubocop:disable Metrics/CyclomaticComplexity
        return nil if request.nil?

        response = JSON.parse(request.body)
        return nil if response["result"].nil?

        @last_request_code = response["code"] || nil
        @last_request_status = response["status"] || nil
        @last_request_paging = response["paging"] || nil
        @last_request_trace_id = response["trace_id"] || nil
        @last_request_messages = response["messages"] || nil

        response["result"]
      end

      def get_full_path(path, function, params = {})
        path.to_s + function.to_s + merge_params(params)
      end

      def merge_params(params = {})
        return "" if params.empty?

        "?".to_s + params.map do |k, v|
          if v.is_a? Array
            v.map { |array_val| escape_param(k, array_val) }.join("&")
          else
            escape_param(k, v)
          end
        end.join("&")
      end

      def escape_param(name, value)
        CGI.escape(name.to_s) + "=".to_s + CGI.escape(value.to_s)
      end
    end
  end
end
