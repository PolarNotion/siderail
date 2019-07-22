require 'rails_helper'

RSpec.describe Admin::SettingsController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe "POST #index" do
    it "returns a success response" do
      post :create, params: {
        setting: {
          site_title: 'New Title',
          admin_email: 'morgan@polarnotion.com'
        }
      }

      expect(response).to redirect_to(admin_settings_path)
    end
  end
end
