# frozen_string_literal: true

RSpec.describe Msci::Esg::ReportAPI do
  before :all do
    @api = Msci::Esg::ReportAPI.new(
      ENV.fetch("MSCI_API_CLIENT_ID", nil),
      ENV.fetch("MSCI_API_SECRET_ID", nil)
    )
    expect(@api.auth).to be true
  end

  it "get list available reports" do
    reports = @api.reports
    expect(reports).to be_a(Hash)
  end
end
