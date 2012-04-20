require "spec_helper"

describe "Subscription webhooks" do
  describe "process webhook" do
    it "handles a past due subscription webhook" do
      signature, payload = Braintree::WebhookTesting.sample_notification(
        Braintree::WebhookNotification::Kind::SubscriptionWentPastDue,
        "my_subscription_id"
      )

      post process_webhook_path, :bt_signature => signature, :bt_payload => payload
      response.should be_success

      NotificationStore.notifications.size.should == 1
      notification = NotificationStore.notifications.first

      notification.kind.should == Braintree::WebhookNotification::Kind::SubscriptionWentPastDue
      notification.subscription.id.should == "my_subscription_id"
    end
  end
end
