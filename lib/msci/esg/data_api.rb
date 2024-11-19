# frozen_string_literal: true

require "json"

module Msci
  module Esg
    class DataAPIError < RuntimeError; end

    # this class will be work with ESG Data API v2
    class DataAPI < BaseAPI
      include ParameterValues
      include Metadata

      API_VERSION = "v2.0"
      BASE_PATH = "https://api.msci.com/esg/data"

      attr_accessor :api_path, :factor_name_list, :category_path_list, :product_name_list
      attr_accessor :index_identifier_list, :esg_industry_id_list, :gics_subindustry_id_list, :country_code_list
      attr_accessor :fund_lipper_global_class_list, :fund_domicile_list, :fund_asset_universe_list, :fund_asset_class_list
      attr_accessor :issuer_identifier_list, :fund_identifier_list, :name_contains, :starts_with, :coverage

      # External parameters
      #   `product_name_list`  (array[string] | empty)
      #       This parameter is a list of one or more product names which contain groups of data factors.
      #       Data factors are grouped by category as well as by product name. A product name is used
      #       to identify a product to which a data factor must belong in order to be returned.
      #       The list of products available to the caller can be found via the `factor_product_names` function.
      #   `category_path_list`  (array[string] | empty)
      #       This parameter is a list of one or more category path strings.
      #       A category path is used to identify a collection of data factors.
      #       All category paths available to the caller can be obtained from the `factor_category_paths` function.
      #   `factor_name_list`  (array[string] | empty)
      #       This is a list of factor names. A factor name is used to identify a unique data point
      #       value associated with an issuer. A full list of available factors for the caller can be
      #       found by using the `factors` function.
      #   `index_identifier_list` (array[string] | empty)
      #       A collection of index identifiers compatible with MSCI ESG Manager.
      #       An index identifier is a string value which identifies an index to use for a query.
      #       Indexes are used to limit the results of a request to a specific set of issuers that
      #       belong to the specified index. A full list of indexes that are available to the caller
      #       can be retrieved at /parameterValues/indexes
      #   `esg_industry_id_list` (array[string] | empty)
      #       This parameter is a list of one or more ESG Industry codes.
      #       The issuers returned will be limited to those belonging to the specified ESG Industries.
      #       The ESG Industry ID is a string value that identifies an ESG Industry.
      #       A full list of available ESG Industries can be retrieved from the `industries` function
      #   `gics_subindustry_id_list` (array[string] | empty)
      #       This parameter is a list of one or more gics subindustry codes.
      #       The issuers returned will be limited to those belonging to the specified GICS Sub Industries.
      #       A GICS SubIndustry code is a string value which is used to identify a particular GICS
      #       SubIndustry. A full list of GICS SubIndustries is available from the `subindustries` function.
      #   `country_code_list` (array[string] | empty)
      #       This parameter contains a list of one or more country codes which is associated with the issuer.
      #       A Country Code is the 2 character code representing a country.
      #   `fund_lipper_global_class_list` (array[string] | empty)
      #       This parameter contains a list of one or more fund lipper global class names.
      #       The available names can be determined by first issuing a request to the `fund_lipper_global_classes` function.
      #       Names from that list may be used in this query to limit results to funds located
      #       in the specified Lipper global classes.
      #   `fund_domicile_list` (array[string] | empty)
      #       This parameter contains a list of one or more fund domicile names.
      #       The available domicile names can be determined by first issuing a request to the `fund_domiciles` function.
      #       Names from that list may be used in this query to limit results to funds located in the specified
      #       domiciles. A Country Code is the 2 character code representing a country.
      #   `fund_asset_universe_list` (array[string] | empty)
      #       This parameter contains a list of one or more fund asset universe names.
      #       The available fund asset universe names can be determined by first issuing a request to the `fund_asset_universes` function.
      #       Names from that list may be used in this query to limit results to funds located in the specified fund
      #       asset universes. A GICS SubIndustry code is a string value which is used to identify a
      #       particular GICS SubIndustry. A full list of GICS SubIndustries is available from the `subindustries` function.
      #   `fund_asset_class_list` (array[string] | empty)
      #       This parameter contains a list of one or more fund asset class names.
      #       The available fund asset class names can be determined by first issuing a request to the `fund_asset_classes` function.
      #       Names from that list may be used in this query to limit results to funds located in the
      #       specified fund asset classes. The ESG Industry ID is a string value that identifies an ESG Industry.
      #       A full list of available ESG Industries can be retrieved from the `industries` function.
      #   `name_contains` (string | nil)
      #       The name_matches string is used to locate issuers whose primary issuer name value contains the given string anywhere in the name.
      #   `starts_with` (string | nil)
      #       Limit the primary issuer to a name that starts with the specified value.
      #   `issuer_identifier_list` (array[string] | empty)
      #       This parameter is used to limit the results to a specific set of issuers.
      #       The caller can list one or more issuer identifiers which identified the issuers for
      #       which data should be returned.
      #   `fund_identifier_list` (array[string] | empty)
      #       This parameter is used to limit the results to a specific set of issuers.
      #       The caller can list one or more issuer identifiers which identified the issuers
      #       for which data should be returned.

      def initialize(client_id, secret_key)
        super
        @audience = "https://esg/data"
        @api_path = BASE_PATH + "/".to_s + API_VERSION

        @factor_name_list = []
        @category_path_list = []
        @product_name_list = []

        @coverage = "esg_ratings"
      end

      # FUNCTION - issuers()
      # This endpoint is used to retrieve factor data based on the parameters given in the request.
      # The results are governed by the data points and issuer coverage permissioned to the account.
      # This request allows the caller to specify which data they want to retrieve,
      # and from which 'universe' of companies.
      #
      # PARAMS
      #
      # Default params:
      #   `format` = "json"
      #   `parent_child` = "do_not_apply"
      #   `reference_column_list` = nil
      #   `issuer_identifier_type` = nil
      # Optional params:
      #   `offset` (int32 | 0)
      #       The Data API has the potential to generate large amounts of data.
      #       The offset value indicates which record to start retrieving values.
      #   `limit` (int32 | 100)
      #       The Data API has the potential to generate large amounts of data.
      #       The limit value indicates the maximum number of records to return
      def issuers(offset: 0, limit: 100)
        params = {
          "format" => "json",
          "parent_child" => "do_not_apply",
          "offset" => offset.to_i,
          "limit" => limit.to_i,
        }
        params = params.merge(_check_params)

        uri = get_full_path(@api_path, "/issuers")
        request = Msci::Esg::Request.post(uri, params, @token)
        result = get_result(request)
        return [] if result["issuers"].nil?

        _clear_params
        result["issuers"]
      end

      # FUNCTION - funds()
      # This endpoint is used to retrieve a set of funds, containing factor data for each fund,
      # based on the parameters given in the request. The results are governed by the data points
      # and fund coverage permissioned to the account. This request allows the caller to specify
      # which data they want to retrieve, and from which 'universe' of funds the results should come from.
      #
      # PARAMS
      #
      # Default params:
      #   `format` = "json"
      #   `fund_metrics_coverage_only` = "true"
      #   `fund_identifier_type` = nil
      # Optional params:
      #   `offset` (int32 | 0)
      #       The Data API has the potential to generate large amounts of data.
      #       The offset value indicates which record to start retrieving values.
      #   `limit` (int32 | 100)
      #       The Data API has the potential to generate large amounts of data.
      #       The limit value indicates the maximum number of records to return
      def funds(offset: 0, limit: 100)
        params = {
          "format" => "json",
          "fund_metrics_coverage_only" => true,
          "offset" => offset.to_i,
          "limit" => limit.to_i,
        }
        params = params.merge(_check_params)

        uri = get_full_path(@api_path, "/funds")
        request = Msci::Esg::Request.post(uri, params, @token)
        result = get_result(request)
        return [] if result["funds"].nil?

        _clear_params
        result["funds"]
      end

      private

      def _check_params
        {
          "index_identifier_list" => @index_identifier_list,
          "esg_industry_id_list" => @esg_industry_id_list,
          "gics_subindustry_id_list" => @gics_subindustry_id_list,
          "country_code_list" => @country_code_list,
          "issuer_identifier_list" => @issuer_identifier_list,
          "fund_lipper_global_class_list" => @fund_lipper_global_class_list,
          "fund_domicile_list" => @fund_domicile_list,
          "fund_asset_universe_list" => @fund_asset_universe_list,
          "fund_asset_class_list" => @fund_asset_class_list,
          "fund_identifier_list" => @fund_identifier_list,
          "factor_name_list" => @factor_name_list,
          "category_path_list" => @category_path_list,
          "product_name_list" => @product_name_list,
          "name_contains" => @name_contains,
          "starts_with" => @starts_with,
          "coverage" => @coverage,
        }
      end

      def _clear_params
        @factor_name_list = nil
        @category_path_list = nil
        @product_name_list = nil
        @index_identifier_list = nil
        @esg_industry_id_list = nil
        @gics_subindustry_id_list = nil
        @country_code_list = nil
        @issuer_identifier_list = nil
        @fund_lipper_global_class_list = nil
        @fund_domicile_list = nil
        @fund_asset_universe_list = nil
        @fund_asset_class_list = nil
        @fund_identifier_list = nil
        @name_contains = nil
        @starts_with = nil
        @coverage = "esg_ratings"
      end
    end
  end
end
