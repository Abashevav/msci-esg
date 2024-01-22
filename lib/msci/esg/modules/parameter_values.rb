# frozen_string_literal: true

require "json"

module Msci
  module Esg
    # this class will be work with ESG Data API v2
    module ParameterValues
      # This endpoint returns a list of indexes to which the accessing account has been permitted.
      # The returned value includes both the index name and the index code.
      # The index code can be used in other requests that can use index IDs as input to the request.
      def indexes
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/indexes"), @token)
        result = get_result(request)
        return [] if result["indexes"].nil?

        result["indexes"]
      end

      # ESG Data is collected for a large number of issuers.
      # In most cases, clients will want to limit the number of issuers they get in a response
      # to only those who have data for a particular coverage universe.
      # For example, a client may wish to only get issues that have ESG Ratings data.
      # The coverage universe is a way to limit the response to issuers that meet particular
      # data characteristics. This endpoint will return a list of data coverage names that are
      # available to the caller.
      def coverages
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/coverages"), @token)
        result = get_result(request)
        return [] if result["coverages"].nil?

        result["coverages"]
      end

      # This endpoint provides a list of ESG Industry codes and names.
      # The industry codes can be used in other endpoints that take an ESG industry id as a parameter.
      def industries
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/esgIndustries"), @token)
        result = get_result(request)
        return [] if result["esg_industries"].nil?

        result["esg_industries"]
      end

      # This endpoint is used to retrieve a list of GICS SubIndustry names and codes.
      # The codes can be used in other endpoints that allow for the specification of GICS SubIndustry ids.
      def subindustries
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/gicsSubIndustries"), @token)
        result = get_result(request)
        return [] if result["gics_sub_industries"].nil?

        result["gics_sub_industries"]
      end

      # This endpoint is used to retrieve a list of country code and corresponding country names
      # that are available to the caller based on their permissions. The country codes can be used
      # in queries for issuer data.
      def countries
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/countries"), @token)
        result = get_result(request)
        return [] if result["countries"].nil?

        result["countries"]
      end

      # This endpoint is used to retrieve a list of fund asset class names.
      # The names can be used in the fund_asset_class_list parameter of the funds endpoint
      # to restrict results to funds that belong to the specified fund asset class names.
      def fund_asset_classes
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/fundAssetClasses"), @token)
        result = get_result(request)
        return [] if result["fund_asset_classes"].nil?

        result["fund_asset_classes"]
      end

      # This endpoint is used to retrieve a list of fund asset universe names.
      # The names can be used in the fund_asset_universe_list parameter of the funds endpoint
      # to restrict results to funds that belong to the specified fund asset universe names.
      def fund_asset_universes
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/fundAssetUniverses"), @token)
        result = get_result(request)
        return [] if result["fund_asset_universes"].nil?

        result["fund_asset_universes"]
      end

      # This endpoint is used to retrieve a list of fund domicile names.
      # The names can be used in the fund_domicile_list parameter of the funds endpoint
      # to restrict results to funds that belong to the specified fund domicile names.
      def fund_domiciles
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/fundDomiciles"), @token)
        result = get_result(request)
        return [] if result["fund_domiciles"].nil?

        result["fund_domiciles"]
      end

      # This endpoint is used to retrieve a list of Lipper global class names.
      # The names can be used in the fund_lipper_global_class_list parameter of the funds endpoint
      # to restrict results to funds that belong to the specified Lipper global class names.
      def fund_lipper_global_classes
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/fundLipperGlobalClasses"), @token)
        result = get_result(request)
        return [] if result["fund_lipper_global_classes"].nil?

        result["fund_lipper_global_classes"]
      end

      # This end point is used to return a list of category paths that are used to identify groups of factors.
      # These paths can be used to define a set of factors that are desired when retrieving data from
      # the issuers endpoint, or as input to the factor metadata endpoint.
      #
      # PARAMS
      #
      # `contains` (string | nil)
      # A string which will be used to match a string of characters anywhere inside of a Category Path.
      #
      # `starts_with` (string | nil)
      # A string which will be used to match the starting characters of a Category Path.
      #
      # `factor_type` (string | nil)
      # The factor_type value is an optional parameter which restricts the category paths to those
      # that contain a particular factor type.
      #
      def factor_category_paths(contains: nil, starts_with: nil, factor_type: nil)
        params = {}
        params["contains"] = contains unless contains.nil?
        params["starts_with"] = starts_with unless starts_with.nil?
        params["factor_type"] = factor_type unless factor_type.nil?
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/factorCategoryPaths", params), @token)
        result = get_result(request)
        return [] if result["category_paths"].nil?

        result["category_paths"]
      end

      # ESG Data Factors are grouped into product categories. This request is used to provide a
      # list of products to which the client has been granted access. The product names can be used
      # in other queries to retrieve a list of factors relating to the specified product(s).
      #
      # PARAMS
      #
      # `contains` (string | nil)
      # The contains parameter is used to limit the response to those product names that contain the given string.
      # This parameter can be combined with the starts_with parameter.
      #
      # `starts_with` (string | nil)
      # This is used to limit the response to those product names that start with the given string.
      # This parameter can be combined with the contains parameter.
      #
      # `factor_type` (string | nil)
      # The factor_type value is an optional parameter which restricts the category paths to those that
      # contain a particular factor type. For example, if the factor_type specified is issuer, only
      # category paths that contain issuer factors will be returned.
      # Note that the available factor types is determined by user permissions.
      #
      def factor_product_names(contains: nil, starts_with: nil, factor_type: nil)
        params = {}
        params["contains"] = contains unless contains.nil?
        params["starts_with"] = starts_with unless starts_with.nil?
        params["factor_type"] = factor_type unless factor_type.nil?
        request = Msci::Esg::Request.get(get_full_path(@api_path, "/parameterValues/factorProductNames", params), @token)
        result = get_result(request)
        return [] if result["product_names"].nil?

        result["product_names"]
      end
    end
  end
end
