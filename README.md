# Msci::Esg

Welcome to MSCI ESG API gem!

Currently only ESG Data API (OAS3) for version 2.0 is available (https://one.msci.com/developerCommunity/apis/esg-data-api).<br>
Other types of MSCI API are also planned to be added in future versions.

## Installation

Install the latest code for the `msci-esg` gem in a project by including this line in your Gemfile:

    $ gem "msci-esg", :git => "git://github.com/Abashevav/msci-esg.git"

After release version 1.0 you can use RubyGems.org for install this Gem.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add msci-esg

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install msci-esg

## Usage

To work with the MSCI API, you need to get the `client_id` and `secret_id`. This can be done in the `OAuth 2.0 Client IDs` tab on the page https://service.msci.com/. Click `Request Client ID`, fill in the required fields and confirm access to the MSCI API.

To get data via API, you need to create an instance of the class and use it for requests.

    $ @msci_api = Msci::Esg::DataAPI.new("client_id", "secret_id")
    $ @msci_api.auth

    $ result = @msci_api.factor_product_names

You can pass parameters to a function

    $ @msci_api.metadata_factors(factor_type: "issuer")

You can use filter options on a class instance to get the data you need.

    $ @msci_api.product_name_list = ["PRODUCT1", "PRODUCT2"]
    $ @msci_api.category_path_list = ["SOME_CATEGORY"]
    $ @msci_api.issuer_identifier_list = ["SOME_ISSUERID"]


To get the result with the configured filters, use the function

    $ result = @msci_api.issuers(limit: LIMIT)

**NOTES**: The `funds` and `issuers` functions clear the filter parameters after each request.

---
### Existing functions and parameters

At the moment, only functions for the MSCI ESG Data API can be implemented.

The two main functions for obtaining data are:
<table>
    <thead>
        <tr>
            <th width=300px>Functions</th>
            <th width=300px>Parameters</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=7>
                issuers()<br><br>
                <small>
                    <i>
                        This endpoint is used to retrieve factor data based on the parameters given in the request. The results are governed by the data points and issuer coverage permissioned to the account. This request allows the caller to specify which data they want to retrieve, and from which 'universe' of companies.
                    </i>
                </small>
            </td>
            <td>`offset`: 0</td>
        </tr>
        <tr>
            <td>`limit`: 100</td>
        </tr>
        <tr>
            <td>`format`: "json"</td>
        </tr>
        <tr>
            <td>`coverage`: "esg_ratings"</td>
        </tr>
        <tr>
            <td>`parent_child`: "do_not_apply"</td>
        </tr>
        <tr>
            <td>`reference_column_list`: nil</td>
        </tr>
        <tr>
            <td>`issuer_identifier_type`: nil</td>
        </tr>
        <tr>
            <td rowspan=4>
                funds()<br><br>
                <small>
                    <i>
                        This endpoint is used to retrieve a set of funds, containing factor data for each fund, based on the parameters given in the request. The results are governed by the data points and fund coverage permissioned to the account. This request allows the caller to specify which data they want to retrieve, and from which 'universe' of funds the results should come from.
                    <i>
                <small>
            </td>
            <td>`offset`: 0</td>
        </tr>
        <tr>
            <td>`limit`: 100</td>
        </tr>
        <tr>
            <td>`fund_metrics_coverage_only` = "true"</td>
        </tr>
        <tr>
            <td>`fund_identifier_type` = nil</td>
        </tr>
    </tbody>
</table>

Both functions can be used with filtering parameters:
<table>
    <thead>
        <tr>
            <th width=200px>Parameter</th>
            <th width=500px>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>product_name_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter is a list of one or more product names which contain groups of data factors. Data factors are grouped by category as well as by product name. A product name is used to identify a product to which a data factor must belong in order to be returned. The list of products available to the caller can be found via the `factor_product_names` function.
            </td>
        </tr>
        <tr>
            <td>category_path_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter is a list of one or more category path strings. A category path is used to identify a collection of data factors. All category paths available to the caller can be obtained from the `factor_category_paths` function.
            </td>
        </tr>
        <tr>
            <td>factor_name_list<br><small>array[string] | empty</small></td>
            <td>
                This is a list of factor names. A factor name is used to identify a unique data point value associated with an issuer. A full list of available factors for the caller can be found by using the `factors` function.
            </td>
        </tr>
        <tr>
            <td>index_identifier_list<br><small>array[string] | empty</small></td>
            <td>
                A collection of index identifiers compatible with MSCI ESG Manager. An index identifier is a string value which identifies an index to use for a query. Indexes are used to limit the results of a request to a specific set of issuers that belong to the specified index. A full list of indexes that are available to the caller can be retrieved at /parameterValues/indexes
            </td>
        </tr>
        <tr>
            <td>esg_industry_id_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter is a list of one or more ESG Industry codes. The issuers returned will be limited to those belonging to the specified ESG Industries. The ESG Industry ID is a string value that identifies an ESG Industry. A full list of available ESG Industries can be retrieved from the `industries` function
            </td>
        </tr>
        <tr>
            <td>gics_subindustry_id_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter is a list of one or more gics subindustry codes. The issuers returned will be limited to those belonging to the specified GICS Sub Industries. A GICS SubIndustry code is a string value which is used to identify a particular GICS SubIndustry. A full list of GICS SubIndustries is available from the `subindustries` function.
            </td>
        </tr>
        <tr>
            <td>country_code_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter contains a list of one or more country codes which is associated with the issuer. A Country Code is the 2 character code representing a country.
            </td>
        </tr>
        <tr>
            <td>fund_lipper_global_class_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter contains a list of one or more fund lipper global class names. The available names can be determined by first issuing a request to the `fund_lipper_global_classes` function. Names from that list may be used in this query to limit results to funds located in the specified Lipper global classes.
            </td>
        </tr>
        <tr>
            <td>fund_domicile_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter contains a list of one or more fund domicile names. The available domicile names can be determined by first issuing a request to the `fund_domiciles` function. Names from that list may be used in this query to limit results to funds located in the specified domiciles. A Country Code is the 2 character code representing a country.
            </td>
        </tr>
        <tr>
            <td>fund_asset_universe_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter contains a list of one or more fund asset universe names. The available fund asset universe names can be determined by first issuing a request to the `fund_asset_universes` function. Names from that list may be used in this query to limit results to funds located in the specified fund asset universes. A GICS SubIndustry code is a string value which is used to identify a particular GICS SubIndustry. A full list of GICS SubIndustries is available from the `subindustries` function.
            </td>
        </tr>
        <tr>
            <td>fund_asset_class_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter contains a list of one or more fund asset class names. The available fund asset class names can be determined by first issuing a request to the `fund_asset_classes` function. Names from that list may be used in this query to limit results to funds located in the specified fund asset classes. The ESG Industry ID is a string value that identifies an ESG Industry. A full list of available ESG Industries can be retrieved from the `industries` function.
            </td>
        </tr>
        <tr>
            <td>name_contains<br><small>string | nil</small></td>
            <td>The name_matches string is used to locate issuers whose primary issuer name value contains the given string anywhere in the name.</td>
        </tr>
        <tr>
            <td>starts_with<br><small>string | nil</small></td>
            <td>Limit the primary issuer to a name that starts with the specified value.</td>
        </tr>
        <tr>
            <td>issuer_identifier_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter is used to limit the results to a specific set of issuers. The caller can list one or more issuer identifiers which identified the issuers for which data should be returned.
            </td>
        </tr>
        <tr>
            <td>fund_identifier_list<br><small>array[string] | empty</small></td>
            <td>
                This parameter is used to limit the results to a specific set of issuers. The caller can list one or more issuer identifiers which identified the issuers for which data should be returned.
            </td>
        </tr>
    </tbody>
</table>

### Additional functions

The description of each parameter can be found in the MSCI API documentation or in the code of this Gem.
<table>
    <thead>
        <tr>
            <th width=500px>Functions</th>
            <th width=200px>Parameters</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=4>metadata_factors()<br><br>
                <small><i>
                This endpoint is used to retrieve information about the factor data that is available to the client. A request can filter results based on category paths, product names, # and factor type (issuer or fund factors). This information can be used to formulate calls to the issuers end point which accepts category paths, product names, and factor IDs as query parameters.
                </i></small>
            </td>
            <td>factor_type<br><small>string | "all" [issuer | fund]</small></td>
        </tr>
        <tr>
            <td>factor_name_list<br><small>array[string] | nil</small></td>
        </tr>
        <tr>
            <td>product_name_list<br><small>array[string] | nil</small></td>
        </tr>
        <tr>
            <td>category_path_list<br><small>array[string] | nil</small></td>
        </tr>
        <tr>
            <td rowspan=3>factor_category_paths()<br><br>
                <small><i>
                This end point is used to return a list of category paths that are used to identify groups of factors. These paths can be used to define a set of factors that are desired when retrieving data from the issuers endpoint, or as input to the factor metadata endpoint.
                </i></small>
            </td>
            <td>contains<br><small>string | nil</small></td>
        </tr>
        <tr>
            <td>starts_with<br><small>string | nil</small></td>
        </tr>
        <tr>
            <td>factor_type<br><small>string | nil</small></td>
        </tr>
        <tr>
            <td rowspan=3>factor_product_names()<br><br>
                <small><i>
                ESG Data Factors are grouped into product categories. This request is used to provide a list of products to which the client has been granted access. The product names can be used in other queries to retrieve a list of factors relating to the specified product(s).
                </i></small>
            </td>
            <td>contains<br><small>string | nil</small></td>
        </tr>
        <tr>
            <td>starts_with<br><small>string | nil</small></td>
        </tr>
        <tr>
            <td>factor_type<br><small>string | nil</small></td>
        </tr>
        <tr>
            <td>indexes()<br><br>
                <small><i>
                    This endpoint returns a list of indexes to which the accessing account has been permitted. The returned value includes both the index name and the index code. The index code can be used in other requests that can use index IDs as input to the request.
                </i></small>
            </td>
            <td>-</td>
        </tr>
        <tr>
            <td>coverages()<br><br>
                <small><i>ESG Data is collected for a large number of issuers. In most cases, clients will want to limit the number of issuers they get in a response to only those who have data for a particular coverage universe.</i></small>
            </td>
            <td>-</td>
        </tr>
        <tr>
            <td>industries()<br><br>
                <small><i>This endpoint provides a list of ESG Industry codes and names. The industry codes can be used in other endpoints that take an ESG industry id as a parameter.</i></small>
            </td>
            <td>-</td>
        </tr>
        <tr>
            <td>subindustries()<br><br>
                <small><i>This endpoint is used to retrieve a list of GICS SubIndustry names and codes. The codes can be used in other endpoints that allow for the specification of GICS SubIndustry ids.</i></small>
            </td>
            <td>-</td>
        </tr>
        <tr>
            <td>countries()<br><br>
                <small><i>This endpoint is used to retrieve a list of country code and corresponding country names that are available to the caller based on their permissions. The country codes can be used in queries for issuer data.</i></small>
            </td>
            <td>-</td>
        </tr>
        <tr>
            <td>fund_asset_classes()<br><br>
                <small><i>This endpoint is used to retrieve a list of fund asset class names. The names can be used in the fund_asset_class_list parameter of the funds endpoint to restrict results to funds that belong to the specified fund asset class names.</i></small>
            </td>
            <td>-</td>
        </tr>
        <tr>
            <td>fund_asset_universes()<br><br>
                <small><i>This endpoint is used to retrieve a list of fund asset universe names. The names can be used in the fund_asset_universe_list parameter of the funds endpoint to restrict results to funds that belong to the specified fund asset universe names.</i></small>
            </td>
            <td>-</td>
        </tr>
        <tr>
            <td>fund_domiciles()<br><br>
                <small><i>This endpoint is used to retrieve a list of fund domicile names. The names can be used in the fund_domicile_list parameter of the funds endpoint to restrict results to funds that belong to the specified fund domicile names.</i></small>
            </td>
            <td>-</td>
        </tr>
        <tr>
            <td>fund_lipper_global_classes()<br><br>
                <small><i>This endpoint is used to retrieve a list of Lipper global class names. The names can be used in the fund_lipper_global_class_list parameter of the funds endpoint to restrict results to funds that belong to the specified Lipper global class names.</i></small>
            </td>
            <td>-</td>
        </tr>
    </tbody>
</table>


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Abashevav/msci-esg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Abashevav/msci-esg/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).