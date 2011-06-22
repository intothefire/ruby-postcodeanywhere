require 'httparty'

module PostcodeAnywhere
  
  ADDRESS_LOOKUP = "http://services.postcodeanywhere.co.uk/xml.aspx"
  ADDRESS_FETCH = "http://services.postcodeanywhere.co.uk/dataset.aspx?action=fetch"

  # Account codes to access the PostcodeAnywhere Service
  mattr_accessor :account_code
  @@account_code = "TEST"
  mattr_accessor :license_code
  @@license_code = "TEST"

  # Default way to setup Devise. Run rails generate devise_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
  
  class PostcodeSearch 
  
  	include HTTParty
  	format :xml

  	attr_accessor :postcode, :country_code, :fetch_id

    def initialize(args={})
      self.postcode = args[:postcode]
      self.country_code = args[:country_code]
      self.fetch_id = args[:fetch_id]
    end

  	def lookup
  		data = PostcodeSearch.get self.lookup_url
  		formatted_data = []
  		unless data["PostcodeAnywhere"]["Schema"]["Field"][0]["Name"] == "error_number"
  		  formatted_data = data["PostcodeAnywhere"]["Data"]["Item"]
  		end
  		formatted_data
  	end
	
  	def fetch
  		data = PostcodeSearch.get self.fetch_url
  		formatted_data = data["NewDataSet"]["Data"]
  		@address_lookup = AddressLookup.new
      if self.country_code == 'GB'
        @address_lookup.postcode = formatted_data["postcode"]
        @address_lookup.address_line_1 = formatted_data["line1"]
        @address_lookup.address_line_2 = formatted_data["line2"]
        @address_lookup.address_line_3 = formatted_data["line3"]
        @address_lookup.post_town = formatted_data["post_town"]
        @address_lookup.county = formatted_data["county"].blank? ? formatted_data["post_town"] : formatted_data["county"]
      elsif self.country_code == 'US'
        @address_lookup.postcode = formatted_data["zip4"].blank? ? @postcode_search.postcode : formatted_data["zip4"]
        @address_lookup.address_line_1 = formatted_data["line1"]
        @address_lookup.address_line_2 = formatted_data["line2"]
        @address_lookup.address_line_3 = formatted_data["line3"]
        @address_lookup.post_town = formatted_data["city"]
        @address_lookup.county = formatted_data["county_name"]+", "+formatted_data["state"]
      else
          
      end
      @address_lookup
  	end

  	def lookup_url
  		ADDRESS_LOOKUP+"?"+self.lookup_type+"&"+self.postcode_with_no_spaces+self.selected_country+"&"+self.license_information
  	end

  	def fetch_url
  		ADDRESS_FETCH+"&"+self.address_fetch_id+self.selected_country+"&"+self.license_information
  	end
	
	  def selected_country
	    if self.country_code == "GB"
  			""
  		else
  			"&country="+self.country_code
  		end
	  end

  	def address_fetch_id
  		"id="+self.fetch_id
  	end

  	def lookup_type
  		if self.country_code == "GB"
  			"action=lookup&type=by_postcode"
  		elsif self.country_code == "US"
  			"action=lookup&type=by_zip"
  		else
  			"action=international&type=fetch_streets"
  		end
  	end

  	def postcode_with_no_spaces
  		(self.country_code=="US" ? "zip=" : "postcode=")+self.postcode.gsub(/\s/, '')
  	end

  	def license_information
  		"account_code="+PostcodeAnywhere.account_code+"&license_code="+PostcodeAnywhere.license_code
  	end
  
  end

  class AddressLookup
  
    attr_accessor :postcode, :address_line_1, :address_line_2, :address_line_3, :post_town, :county
    attr_accessor :city, :county_name, :zip4, :state
    
  end
end