# frozen_string_literal: true

require_relative "esg/version"
require_relative "esg/helpers/date"
require_relative "esg/helpers/request"
require_relative "esg/modules/metadata"
require_relative "esg/modules/parameter_values"
require_relative "esg/base_api"
require_relative "esg/data_api"
require_relative "esg/report_api"

module Msci
  module Esg
    class Error < StandardError; end
  end
end
