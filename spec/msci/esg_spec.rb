# frozen_string_literal: true

RSpec.describe Msci::Esg do
  it "has a version number" do
    expect(Msci::Esg::VERSION).not_to be nil
  end

  it "bad auth" do
    expect(Msci::Esg::DataAPI.new("AA", "BB").auth).not_to be nil
  end
end
