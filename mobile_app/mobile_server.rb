require 'sinatra'
require 'braintree'
Braintree::Configuration.environment = :development
Braintree::Configuration.merchant_id = "integration_merchant_id"
Braintree::Configuration.public_key = "integration_public_key"
Braintree::Configuration.private_key = "integration_private_key"

get "/transaction_tr" do
  tr_data =  Braintree::TransparentRedirect.transaction_data({
    :redirect_url => "http://localhost:3031",
    :transaction => {
      :amount => "10.03",
      :type => "sale"
    }
  })

  tr_data
end

get "/confirm" do
  result = Braintree::TransparentRedirect.confirm(request.query_string)
  "OK"
end
