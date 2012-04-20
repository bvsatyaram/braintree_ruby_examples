class WebhooksController < ApplicationController
  def create
    signature, payload = Braintree::WebhookTesting.sample_notification(
      Braintree::WebhookNotification::Kind::SubscriptionWentPastDue,
      rand(10000)
    )
    NotificationStore.add(Braintree::WebhookNotification.parse(signature, payload))
    redirect_to webhooks_path
  end

  def destroy_all
    NotificationStore.clear
    redirect_to webhooks_path
  end

  def handle
    NotificationStore.add(Braintree::WebhookNotification.parse(params[:bt_signature], params[:bt_payload]))
    head :ok
  end

  def index
    @notifications = NotificationStore.notifications
  end

  def verify
    render :text => Braintree::WebhookNotification.verify(params[:bt_challenge])
  end
end
