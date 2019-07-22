require 'rails_helper'

RSpec.describe Admin::PagesController, type: :controller do
  describe "GET #dashboard" do
    it "returns a success response" do
      get :dashboard, params: {}
      expect(response).to be_successful
    end
  end
end
