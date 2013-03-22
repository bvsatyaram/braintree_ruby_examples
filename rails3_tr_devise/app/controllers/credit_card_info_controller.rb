class CreditCardInfoController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @credit_card = Braintree::CreditCard.find(params[:id])
    fetch_transparent_redirect_data
  end

  def confirm
    @result = Braintree::TransparentRedirect.confirm(request.query_string)

    if @result.success?
      render :action => "confirm"
    else
      @credit_card = Braintree::CreditCard.find(@result.params[:payment_method_token])
      fetch_transparent_redirect_data
      render :action => "edit"
    end
  end

  private
    def fetch_transparent_redirect_data
      @tr_data = Braintree::TransparentRedirect.
                  update_credit_card_data(:redirect_url => confirm_credit_card_info_url,
                                          :payment_method_token => @credit_card.token)
    end
end
