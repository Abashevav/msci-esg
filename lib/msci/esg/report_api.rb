# frozen_string_literal: true

require "json"

module Msci
  module Esg
    class ReportAPIError < RuntimeError; end

    # this class will be work with ESG Report API v2
    class ReportAPI < BaseAPI
      API_VERSION = "v2.0"
      BASE_PATH = "https://api.msci.com/esg/report"

      def initialize(client_id, secret_key)
        super
        @audience = "https://esg/report"
      end

      # This endpoint will return a JSON object, in HATEOAS format,
      # which displays the available routes that are available to the caller.
      # The routes are based on the features that have been granted to the calling user.
      # The result display links in templated form which can be used to interact with the API.
      def reports
        request = Msci::Esg::Request.get(
          BASE_PATH + "/".to_s + API_VERSION + "/reports/".to_s,
          @token
        )
        response = JSON.parse(request.body) unless request.nil?
        response["_links"] unless response.nil?
      end
    end
  end
end
