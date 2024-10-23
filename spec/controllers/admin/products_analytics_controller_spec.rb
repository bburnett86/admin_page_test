# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ProductsAnalyticsController, type: :controller do
  fixtures :users

  describe "GET #line_graph_data" do
    context "when user is an admin" do
      before do
        admin_user = users(:admin_user_one)
        sign_in admin_user
      end

      it "returns a successful response with valid params" do
        get :line_graph_data, params: { type: "revenue" }, format: :json
        expect(response).to have_http_status(:success)
      end

      it "returns an error with invalid params" do
        get :line_graph_data, params: { type: "invalid_type" }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid type")
      end
    end

    # context "when user is not an admin" do
    #   before do
    #     standard_user = users(:standard_user_one)
    #     sign_in standard_user
    #   end

    #   it "denies access" do
    #     valid_type = "revenue"
    #     get :line_graph_data, params: { type: valid_type }, format: :json
    #     expect(response).to have_http_status(:forbidden)
    #   end
    # end
  end

  describe "GET #calculate_multiple_finance_line_graph_metrics" do
    context "when user is an admin" do
      before do
        admin_user = users(:admin_user_one)
        sign_in admin_user
      end

      it "returns a successful response with valid params" do
        get :calculate_multiple_finance_line_graph_metrics, params: { excluded_types: %w[revenue cost] }, format: :json
        expect(response).to have_http_status(:success)
      end

      it "returns a successful response with no params" do
        get :calculate_multiple_finance_line_graph_metrics, format: :json
        expect(response).to have_http_status(:success)
      end

      it "returns an error with invalid params" do
        get :calculate_multiple_finance_line_graph_metrics, params: { excluded_types: ["invalid_type"] }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid excluded_types")
      end
    end

    # context "when user is not an admin" do
    #   before do
    #     standard_user = users(:standard_user_one)
    #     sign_in standard_user
    #   end

    #   it "denies access" do
    #     get :calculate_multiple_finance_line_graph_metrics, params: { excluded_types: %w[revenue cost] }, format: :json
    #     expect(response).to have_http_status(:forbidden)
    #   end
    # end
  end
end