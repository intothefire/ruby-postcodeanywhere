require 'spec_helper'

WebMock.disable_net_connect!

describe PostcodeAnywhere::BankAccountValidation do
  subject { PostcodeAnywhere::BankAccountValidation.new 'key' }
  let :json_response do
    <<-JSON
{
    "Items": [
        {
            "IsCorrect": false,
            "IsDirectDebitCapable": false,
            "StatusInformation": "UnknownSortCode",
            "CorrectedSortCode": "",
            "CorrectedAccountNumber": "",
            "IBAN": "",
            "Bank": "",
            "BankBIC": "",
            "Branch": "",
            "BranchBIC": "",
            "ContactAddressLine1": "",
            "ContactAddressLine2": "",
            "ContactPostTown": "",
            "ContactPostcode": "",
            "ContactPhone": "",
            "ContactFax": "",
            "FasterPaymentsSupported": false,
            "CHAPSSupported": false
        }
    ]
}
    JSON
  end

  let :json_error_response do
    <<-JSON
{
    "Items": [
        {
            "Error": "1002",
            "Description": "SortCode Invalid",
            "Cause": "SortCode Invalid",
            "Resolution": "The SortCode parameter should be 6 digits in the form 00-00-00 or 000000. It should be prefixed with leading 0s if necessary."
        }
    ]
}
    JSON
  end

  it "sends a valid request when validating a bank account" do
    ret = make_bav_request :response => json_response
    
    ret.should_not be_correct
    ret.should_not be_direct_debit_capable
    ret.status_information.should == 'UnknownSortCode'
    ret.corrected_sort_code.should == ''
    ret.corrected_account_number.should == ''
    ret.iban.should == ''
    ret.bank.should == ''
    ret.bank_bic.should == ''
    ret.branch.should == ''
    ret.branch_bic.should == ''
    ret.contact_address_line1.should == ''
    ret.contact_address_line2.should == ''
    ret.contact_post_town.should == ''
    ret.contact_postcode.should == ''
    ret.contact_phone.should == ''
    ret.contact_fax.should == ''
    ret.faster_payments_supported.should == false
    ret.should_not be_faster_payments_supported
    ret.chaps_supported.should == false
    ret.should_not be_chaps_supported
  end
  
  it "handles errors" do
    begin
      make_bav_request :response => json_error_response
      fail 'should raise exception'
    rescue PostcodeAnywhere::BankAccountException => e
      e.error.should == 1002
      e.description.should == "SortCode Invalid"
      e.cause.should == "SortCode Invalid"
      e.resolution.should == "The SortCode parameter should be 6 digits in the form 00-00-00 or 000000. It should be prefixed with leading 0s if necessary."
    end
  end
  def make_bav_request(options)
    stub_request(:get,
                 'https://services.postcodeanywhere.co.uk/BankAccountValidation/Interactive/Validate/v2.00/json3.ws?AccountNumber=account_number&Key=key&SortCode=sort_code'
                 ).to_return(:body => options[:response])
    ret = subject.validate('sort_code', 'account_number')
  end
end

