require 'httparty'
require 'active_support/core_ext/module/attribute_accessors'

module PostcodeAnywhere

  # Account codes to access the PostcodeAnywhere Service
  mattr_accessor :account_code
  @@account_code = "TEST"
  mattr_accessor :license_code
  @@license_code = "TEST"

  def self.setup
    yield self
  end

  class PostcodeSearch
  	include HTTParty

  	base_uri 'https://services.postcodeanywhere.co.uk/PostcodeAnywhere/Interactive'

    ADDRESS_LOOKUP = "/Find/v1.10/xmla.ws"
    ADDRESS_FETCH = "/RetrieveById/v1.20/xmla.ws"
    RETRIEVE_BY_PARTS_URL = "/RetrieveByParts/v1.00/xmla.ws"

  	def lookup(postcode)

  	  raise "Postcode is Required" if postcode.blank? || postcode.nil?

  	  options={ "SearchTerm" => postcode.gsub(/\s/, '') }
      options.merge!(self.license_information)

  		data = PostcodeSearch.get( ADDRESS_LOOKUP, {:query => options} )
  		formatted_data = []

	    return formatted_data if data.parsed_response['Table']['Columns']['Column'][0]['Name'] == "Error"

	    puts formatted_data

  		unless data.parsed_response['Table']['Columns']['Column'][0]['Name'] == "Error"

  		  begin
  	  	  data.parsed_response["Table"]["Rows"]["Row"].each do |item|
    		    data_item = AddressListItem.new
    		    data_item.id = item['Id']
    		    data_item.street_address = item['StreetAddress']
    		    data_item.place = item['Place']

    		    formatted_data << data_item
  		    end
  	    rescue
  	      item = data.parsed_response["Table"]["Rows"]["Row"]
  		    data_item = AddressListItem.new
  		    data_item.id = item['Id']
  		    data_item.street_address = item['StreetAddress']
  		    data_item.place = item['Place']

  		    formatted_data << data_item
        end
  		end
  		formatted_data
  	end

  	def fetch_by_parts(options={})
      options.merge!(self.license_information)

      if options['postcode']
        options['postcode'] = options['postcode'].gsub(/\s/, '')
      end

  		data = PostcodeSearch.get( RETRIEVE_BY_PARTS_URL, {:query => options} )

  		process_address(data)
  	end

  	def fetch(id)
  	  options={ :id => id }
      options.merge!(self.license_information)

  		data = PostcodeSearch.get( ADDRESS_FETCH, {:query => options} )

  		process_address(data)
  	end

  	def license_information
  		{:account_code => PostcodeAnywhere.account_code, :license_code => PostcodeAnywhere.license_code}
  	end


  	private
  	  def process_address(data)

  	    raise 'No Data Found' if data.parsed_response['Table']['Columns']['Column'][0]['Name'] == "Error"

  	    formatted_data = data.parsed_response["Table"]["Rows"]["Row"]

    		address_lookup = AddressLookup.new

        address_lookup.mailsort = formatted_data["Mailsort"]
        address_lookup.barcode = formatted_data["Barcode"]
        address_lookup.type = formatted_data["Type"]

        address_lookup.udprn = formatted_data["Udprn"]
        address_lookup.company = formatted_data["Company"]
        address_lookup.department = formatted_data["Department"]
        address_lookup.postcode = formatted_data["Postcode"]
        address_lookup.address_line_1 = formatted_data["Line1"]
        address_lookup.address_line_2 = formatted_data["Line2"]
        address_lookup.address_line_3 = formatted_data["Line3"]
        address_lookup.address_line_4 = formatted_data["Line4"]
        address_lookup.address_line_5 = formatted_data["Line5"]
        address_lookup.building_name = formatted_data["BuildingName"]
        address_lookup.building_number = formatted_data["BuildingNumber"]
        address_lookup.street = formatted_data["PrimaryStreet"]
        address_lookup.flat = formatted_data["SubBuilding"]
        address_lookup.district = formatted_data["DependentLocality"]
        address_lookup.post_town = formatted_data["PostTown"]
        address_lookup.county = formatted_data["County"].blank? ? formatted_data["PostTown"] : formatted_data["County"]


        address_lookup
	    end


  end

  class AddressLookup

    attr_accessor :building_name, :building_number, :street, :flat, :district
    attr_accessor :postcode, :address_line_1, :address_line_2, :address_line_3, :address_line_4, :address_line_5
    attr_accessor :post_town, :county, :city, :county_name, :zip4, :state, :udprn, :company, :department
    attr_accessor :mailsort, :barcode, :type

  end

  class AddressListItem

      attr_accessor :id, :street_address, :place

  end

end
