# frozen_string_literal: true

require 'spec_helper'

WebMock.disable_net_connect!

describe PostcodeAnywhere::BankAccountValidation do
  subject { PostcodeAnywhere::BankAccountValidation.new 'key' }
  let :json_response do
    <<~JSON
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
    <<~JSON
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

  it 'sends a valid request when validating a bank account' do
    ret = make_bav_request response: json_response

    expect(ret).to_not be_correct
    expect(ret).to_not be_direct_debit_capable
    expect(ret.status_information).to eq 'UnknownSortCode'
    expect(ret.corrected_sort_code).to eq ''
    expect(ret.corrected_account_number).to eq ''
    expect(ret.iban).to eq ''
    expect(ret.bank).to eq ''
    expect(ret.bank_bic).to eq ''
    expect(ret.branch).to eq ''
    expect(ret.branch_bic).to eq ''
    expect(ret.contact_address_line1).to eq ''
    expect(ret.contact_address_line2).to eq ''
    expect(ret.contact_post_town).to eq ''
    expect(ret.contact_postcode).to eq ''
    expect(ret.contact_phone).to eq ''
    expect(ret.contact_fax).to eq ''
    expect(ret.faster_payments_supported).to eq false
    expect(ret).to_not be_faster_payments_supported
    expect(ret.chaps_supported).to eq false
    expect(ret).to_not be_chaps_supported
  end

  it 'handles errors' do
    make_bav_request response: json_error_response
    raise 'should raise exception'
  rescue PostcodeAnywhere::BankAccountException => e
    expect(e.error).to eq 1002
    expect(e.description).to eq 'SortCode Invalid'
    expect(e.cause).to eq 'SortCode Invalid'
    expect(e.resolution).to eq 'The SortCode parameter should be 6 digits in the form 00-00-00 or 000000. It should be prefixed with leading 0s if necessary.'
  end
  def make_bav_request(options)
    stub_request(
      :get,
      'https://services.postcodeanywhere.co.uk/BankAccountValidation/Interactive/Validate/v2.00/json3.ws?AccountNumber=account_number&Key=key&SortCode=sort_code'
    ).to_return(body: options[:response])

    subject.validate('sort_code', 'account_number')
  end
end
