require "rails_helper"

describe OrdersController, type: :controller do
  describe "GET index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "PATCH order" do
    it "returns a successful response" do
      form_params = {
        id: "316c6832-e038-4599-bc32-2b0bf1b9f1c1"
      }
      patch :update, params: form_params
      expect(response).to redirect_to "/orders"
    end
  end
end