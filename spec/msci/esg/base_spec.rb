# frozen_string_literal: true

RSpec.describe Msci::Esg do
  context "Auth" do
    it "bad auth" do
      base = Msci::Esg::BaseAPI.new("AA", "BB")
      expect(base.auth).not_to be true
    end

    it "true auth" do
      base = Msci::Esg::BaseAPI.new(ENV["MSCI_API_CLIENT_ID"], ENV["MSCI_API_SECRET_ID"])
      expect(base.auth).to be true
    end
  end
end
