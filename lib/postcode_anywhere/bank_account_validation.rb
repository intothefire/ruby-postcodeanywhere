require 'json'
#require 'active_support/inflector/methods'
require 'active_support/core_ext/string/inflections'

module PostcodeAnywhere
  class BankAccountValidation
    include HTTParty
    base_uri 'https://services.postcodeanywhere.co.uk/BankAccountValidation/Interactive/Validate/v2.00/json3.ws'
    format :html
    def initialize(key)
      self.class.default_params :Key => key
    end
    def validate(sort_code, account_number)
      http_response = self.class.get('', :query => {:SortCode => sort_code, :AccountNumber => account_number})

      r = JSON.parse(http_response)
      raise unless r.length == 1
      r = r["Items"]
      raise unless r.length == 1
      r = r[0]
      
      r2 = BankAccountResult.new
      r.each do |k, v|
        r2.send "#{k.underscore}=", v
      end

      r2
    end
  end

  class BankAccountResult
    ATTRIBUTES = [:is_correct,
                  :is_direct_debit_capable,
                  :status_information,
                  :corrected_sort_code,
                  :corrected_account_number,
                  :iban,
                  :bank,
                  :bank_bic,
                  :branch,
                  :branch_bic,
                  :contact_address_line1,
                  :contact_address_line2,
                  :contact_post_town,
                  :contact_postcode,
                  :contact_phone,
                  :contact_fax,
                  :faster_payments_supported,
                  :chaps_supported]
    attr_accessor *ATTRIBUTES

    def correct?
      is_correct
    end
    def direct_debit_capable?
      is_direct_debit_capable
    end
    def faster_payments_supported?
      faster_payments_supported
    end
    def chaps_supported?
      chaps_supported
    end
  end
end

