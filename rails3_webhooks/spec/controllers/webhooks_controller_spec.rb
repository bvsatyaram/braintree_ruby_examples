require 'spec_helper'

describe WebhooksController do
  describe "index" do
    it "displays notifications from the store" do
      NotificationStore.add(:notification1)
      NotificationStore.add(:notification2)

      get :index

      assigns[:notifications].should == [:notification1, :notification2]
    end
  end

  describe "verify" do
    it "returns a webhook verification response" do
      get :verify, :bt_challenge => "1234"
      response.body.should == Braintree::WebhookNotification.verify("1234")
    end
  end

  describe "create" do
    it "creates a new notification" do
      expect do
        post :create
      end.to change { NotificationStore.notifications.size }.by(1)

      response.should redirect_to(webhooks_path)
    end
  end

  describe "destroy_all" do
    it "clears out the existing notifications" do
      NotificationStore.add(:notification1)
      NotificationStore.add(:notification2)

      delete :destroy_all

      NotificationStore.notifications.should be_empty
      response.should redirect_to(webhooks_path)
    end
  end
end
