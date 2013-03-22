class CustomerController < ApplicationController
  before_filter :authenticate_user!

  def new
    fetch_new_transparent_redirect_data
  end

  def edit
    fetch_edit_transparent_redirect_data
  end

  def confirm
    @result = Braintree::TransparentRedirect.confirm(request.query_string)

    if @result.success?
      current_user.braintree_customer_id = @result.customer.id
      current_user.save!
      render :action => "confirm"
    elsif current_user.has_payment_info?
      fetch_edit_transparent_redirect_data
      render :action => "edit"
    else
      fetch_new_transparent_redirect_data
      render :action => "new"
    end
  end

  private
    def fetch_new_transparent_redirect_data
      @tr_data = Braintree::TransparentRedirect.
                  create_customer_data(:redirect_url => confirm_customer_url)
    end

    def fetch_edit_transparent_redirect_data
      current_user.with_braintree_data!
      @credit_card = current_user.default_credit_card
      @tr_data = Braintree::TransparentRedirect.
                  update_customer_data(:redirect_url => confirm_customer_url,
                                       :customer_id => current_user.braintree_customer_id)
    end
end
