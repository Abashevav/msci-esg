# frozen_string_literal: true

RSpec.describe Msci::Esg::DataAPI do
  before :all do
    @api = Msci::Esg::DataAPI.new(
      ENV.fetch("MSCI_API_CLIENT_ID", nil),
      ENV.fetch("MSCI_API_SECRET_ID", nil)
    )
    expect(@api.auth).to be true
  end

  context "parameter values functions" do
    it "get list available indexes" do
      indexes = @api.indexes
      expect(indexes).to be_a(Array)
      expect(indexes.size).to be >= 0
    end

    it "get list available industries" do
      industries = @api.industries
      expect(industries).to be_a(Array)
      expect(industries.size).to be > 0
    end

    it "get list available subindustries" do
      subindustries = @api.subindustries
      expect(subindustries).to be_a(Array)
      expect(subindustries.size).to be > 0
    end

    it "get list available countries" do
      countries = @api.countries
      expect(countries).to be_a(Array)
      expect(countries.size).to be > 0
    end

    it "get list available coverages" do
      coverages = @api.coverages
      expect(coverages).to be_a(Array)
      expect(coverages.size).to be > 0
    end

    it "get list available fund_asset_universes" do
      fau = @api.fund_asset_universes
      expect(fau).to be_a(Array)
      expect(fau.size).to be > 0
    end

    it "get list available fund_asset_classes" do
      fac = @api.fund_asset_classes
      expect(fac).to be_a(Array)
      expect(fac.size).to be > 0
    end

    it "get list available fund_domiciles" do
      fd = @api.fund_domiciles
      expect(fd).to be_a(Array)
      expect(fd.size).to be > 0
    end

    it "get list available fund_lipper_global_classes" do
      flgc = @api.fund_lipper_global_classes
      expect(flgc).to be_a(Array)
      expect(flgc.size).to be > 0
    end
  end

  context "factor category paths function" do
    it "get list available factor category paths" do
      fcp_res = @api.factor_category_paths
      expect(fcp_res).to be_a(Array)
      expect(fcp_res.size).to be >= 0
    end

    it "get list factors category paths contains Carbon" do
      fcp_res = @api.factor_category_paths(contains: "Carbon")
      expect(fcp_res).to be_a(Array)
      expect(fcp_res.size).to be >= 0
    end

    it "get list factors category paths starts with ESG Ratings" do
      fcp_res = @api.factor_category_paths(starts_with: "ESG Ratings")
      expect(fcp_res).to be_a(Array)
      expect(fcp_res.size).to be >= 0
    end

    it "get list factors category paths starts with ESG Ratings and contains Carbon" do
      fcp_res = @api.factor_category_paths(contains: "Carbon", starts_with: "ESG Ratings")
      expect(fcp_res).to be_a(Array)
      expect(fcp_res.size).to be >= 0
    end

    it "get list factors category paths that contains a some factor type" do
      fcp_res = @api.factor_category_paths(factor_type: "instrument")
      expect(fcp_res).to be_a(Array)
      expect(fcp_res.size).to be >= 0
    end

    it "get list factors category paths that contains Issuer and starts with Other and a some factor type" do
      fcp_res = @api.factor_category_paths(contains: "Issuer", starts_with: "Other", factor_type: "fund")
      expect(fcp_res).to be_a(Array)
      expect(fcp_res.size).to eq(0)
    end
  end

  context "factor product names function" do
    it "get list available factor product names" do
      fpn_res = @api.factor_product_names
      expect(fpn_res).to be_a(Array)
      expect(fpn_res.size).to be >= 0
    end

    it "get list factors product names contains Monitor" do
      fpn_res = @api.factor_product_names(contains: "Monitor")
      expect(fpn_res).to be_a(Array)
      expect(fpn_res.size).to be >= 0
    end

    it "get list factors product names starts with Excludable" do
      fpn_res = @api.factor_product_names(starts_with: "Excludable")
      expect(fpn_res).to be_a(Array)
      expect(fpn_res.size).to be >= 0
    end

    it "get list factors product names starts with ESG and contains Monitor" do
      fpn_res = @api.factor_product_names(contains: "Monitor", starts_with: "ESG")
      expect(fpn_res).to be_a(Array)
      expect(fpn_res.size).to be >= 0
    end

    it "get list factors product names that contains a some factor type" do
      fpn_res = @api.factor_product_names(factor_type: "issuer")
      expect(fpn_res).to be_a(Array)
      expect(fpn_res.size).to be >= 0
    end

    it "get list factors product names that contains Monitor and starts with ESG and a some factor type" do
      fpn_res = @api.factor_product_names(contains: "Monitor", starts_with: "ESG", factor_type: "issuer")
      expect(fpn_res).to be_a(Array)
      expect(fpn_res.size).to be >= 0
    end
  end

  context "metadata factors function" do
    it "get list metadata related to the data factors" do
      mf = @api.metadata_factors
      expect(mf).to be_a(Array)
      expect(mf.size).to be >= 0
    end

    it "get list metadata related to single factor type" do
      mf = @api.metadata_factors("fund")
      expect(mf).to be_a(Array)
      expect(mf.size).to be >= 0
    end

    it "get list metadata related to some data factors" do
      mf = @api.metadata_factors("all", %w[ABORTION_ALL_TIE FUND_ESG_COVERAGE])
      expect(mf).to be_a(Array)
      expect(mf.size).to be >= 0
    end

    it "get list metadata related to some product name list" do
      mf = @api.metadata_factors("all", [], ["Fund Free Access"])
      expect(mf).to be_a(Array)
      expect(mf.size).to be >= 0
    end

    it "get list metadata related to some category path list" do
      mf = @api.metadata_factors("all", [], [], ["Fund Metrics:Summary"])
      expect(mf).to be_a(Array)
      expect(mf.size).to be >= 0
    end

    it "get list metadata with each params" do
      mf = @api.metadata_factors(
        "all",
        %w[ABORTION_ALL_TIE FUND_ESG_COVERAGE],
        ["Fund Free Access"],
        ["Fund Metrics:Summary"]
      )
      expect(mf).to be_a(Array)
      expect(mf.size).to be >= 0
    end
  end

  context "Issuers function" do
    it "get list with first 100 issuers" do
      issuers = @api.issuers
      expect(issuers).to be_a(Array)
      expect(issuers.size).to eq(100)
    end

    context "Issuers general filters" do
      it "get list with issuers with name contains `Bank`" do
        @api.name_contains = "BANK"
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
      end

      it "get list with issuers with name starts with `Bank`" do
        @api.starts_with = "BANK"
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
      end

      it "get list with issuers for single issuer_id" do
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
        unless issuers.empty?
          @api.issuer_identifier_list = [issuers[0]["ISSUERID"]]
          issuers_with_id = @api.issuers
          expect(issuers_with_id).to be_a(Array)
          expect(issuers_with_id.size).to be > 0
        end
      end
    end

    context "Issuers external filters" do
      it "get list with issuers with some index_identifier_list" do
        @api.index_identifier_list = %w[UNX000000020611598 MSC000000000990100]
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
      end

      it "get list with issuers with Airlines esg industry" do
        @api.esg_industry_id_list = %w[12884]
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
        unless issuers.empty?
          expect(issuers[0]["IVA_INDUSTRY"]).to eq("Airlines")
        end
      end

      it "get list with issuers with some GICS subindustry" do
        @api.gics_subindustry_id_list = %w[40101015]
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
      end

      it "get list with issuers with US country code" do
        @api.country_code_list = %w[US]
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
        unless issuers.empty?
          expect(issuers[0]["ISSUER_CNTRY_DOMICILE"]).to eq("US")
        end
      end

      it "get list with issuers with different offset" do
        issuers_part1 = @api.issuers(offset: 0, limit: 2)
        issuers_part2 = @api.issuers(offset: 1, limit: 2)
        expect(issuers_part1).to be_a(Array)
        expect(issuers_part1.size).to be > 0

        expect(issuers_part2).to be_a(Array)
        expect(issuers_part2.size).to be > 0

        last_company_from_part1 = issuers_part1.last
        first_company_from_part2 = issuers_part2.first
        expect(last_company_from_part1).to eq(first_company_from_part2)
      end

      it "get list with issuers with different limit" do
        issuers = @api.issuers(limit: 7)
        expect(issuers).to be_a(Array)
        expect(issuers.size).to eq(7)
      end
    end

    context "Issuers fields" do
      it "get list with issuers with some factor_name_list" do
        @api.factor_name_list = ["BARCAP"]
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
      end

      it "get list with issuers with some category_path_list" do
        @api.category_path_list = ["GovernanceMetrics:Raw Data:Board"]
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
      end

      it "get list with issuers with some product_name_list" do
        @api.product_name_list = ["GovernanceMetrics"]
        issuers = @api.issuers
        expect(issuers).to be_a(Array)
        expect(issuers.size).to be >= 0
      end
    end
  end

  context "Funds function" do
    it "get list with first 100 funds" do
      funds = @api.funds
      expect(funds).to be_a(Array)
      expect(funds.size).to eq(100)
    end

    context "Funds general filters" do
      it "get list with funds with name contains `Bank`" do
        @api.name_contains = "BANK"
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
      end

      it "get list with funds with name starts with `Bank`" do
        @api.starts_with = "BANK"
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
      end

      it "get list with funds for single funds_id" do
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
        unless funds.empty?
          @api.fund_identifier_list = [funds[0]["FUND_ID"]]
          funds_with_id = @api.funds
          expect(funds_with_id).to be_a(Array)
          expect(funds_with_id.size).to be > 0
        end
      end
    end

    context "Funds external filters" do
      it "get list with funds with some fund_lipper_global_class_list" do
        @api.fund_lipper_global_class_list = %w[Unclassified]
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
        unless funds.empty?
          expect(funds[0]["FUND_LIPPER_GLOBAL_CLASS"]).to eq("Unclassified")
        end
      end

      it "get list with funds with some fund_domicile_list" do
        @api.fund_domicile_list = %w[USA]
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
        unless funds.empty?
          expect(funds[0]["FUND_DOMICILE"]).to eq("USA")
        end
      end

      it "get list with funds with some fund_asset_universe_list" do
        @api.fund_asset_universe_list = ["Investment Trust"]
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
      end

      it "get list with funds with some fund_asset_class_list" do
        @api.fund_asset_class_list = %w[Other]
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
      end

      it "get list with funds with different offset" do
        funds_part1 = @api.funds(offset: 0, limit: 2)
        funds_part2 = @api.funds(offset: 1, limit: 2)
        expect(funds_part1).to be_a(Array)
        expect(funds_part1.size).to be > 0

        expect(funds_part2).to be_a(Array)
        expect(funds_part2.size).to be > 0

        last_company_from_part1 = funds_part1.last
        first_company_from_part2 = funds_part2.first
        expect(last_company_from_part1).to eq(first_company_from_part2)
      end

      it "get list with funds with different limit" do
        funds = @api.funds(limit: 7)
        expect(funds).to be_a(Array)
        expect(funds.size).to eq(7)
      end
    end

    context "Funds fields" do
      it "get list with funds with some factor_name_list" do
        @api.factor_name_list = ["HOLDING_DATE"]
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
      end

      it "get list with funds with some category_path_list" do
        @api.category_path_list = ["Fund Metrics:Summary"]
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
      end

      it "get list with funds with some product_name_list" do
        @api.product_name_list = ["GovernanceMetrics"]
        funds = @api.funds
        expect(funds).to be_a(Array)
        expect(funds.size).to be >= 0
      end
    end
  end
end
