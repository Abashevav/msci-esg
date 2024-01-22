# frozen_string_literal: true

require "json"

module Msci
  module Esg
    # this class will be work with ESG Data API v2
    module Metadata
      # This endpoint is used to retrieve information about the factor data that is available to the client.
      # A request can filter results based on category paths, product names, # and factor type (issuer or fund factors).
      # This information can be used to formulate calls to the issuers end point which accepts category paths,
      # product names, and factor IDs as query parameters.
      #
      # PARAMS
      #
      # `factor_type` (string | "all")
      # Factor Type is an optional value which will restrict the return factors to the specified type.
      # If this option is not specified, all factor types will be returned.
      # Available options are issuer, fund, and all. Note the options that are available are based on user permissions.
      # Some users may only be allowed to use fund or all, other users may only be able to use issuers or all.
      #
      # `factor_name_list` (array[string] | nil)
      # A caller can specify one or more factor names for which they want to retrieve factor metadata.
      # Data will be returned for all valid factor names, along with a list of any factor names which
      # weren't recognized. If a name isn't recognized, it could be the factor doesn't exist,
      # or the caller doesn't have access to that factor.
      #
      # `product_name_list` (array[string] | nil)
      # ESG Data Factors are grouped into various product classifications.
      # A user can specify a list of product names to limit the factors that are returned for this query. ESG Impact Monitor
      #
      # `category_path_list` (array[string] | nil)
      # ESG Data Factors are organized into a hierarchy of categories.
      # Category Paths are used to located a group of factors that belong to the specified path(s). Add string item
      #
      def metadata_factors(factor_type = "all", factor_name_list = [], product_name_list = [], category_path_list = [])
        params = {}
        params["factor_name_list"] = factor_name_list unless factor_name_list.empty?
        params["factor_type"] = factor_type unless factor_type.nil?
        params["product_name_list"] = product_name_list unless product_name_list.empty?
        params["category_path_list"] = category_path_list unless category_path_list.empty?

        request = Msci::Esg::Request.get(
          get_full_path(@api_path, "/metadata/factors", params),
          @token
        )
        result = get_result(request)
        return [] if result["factors"].nil?

        result["factors"]
      end
    end
  end
end
