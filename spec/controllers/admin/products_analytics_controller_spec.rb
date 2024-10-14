# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ProductsAnalyticsController, type: :controller do
  fixtures :users

  describe "GET #calculate_multiple_finance_line_graph_metrics" do
    context "when user is an admin" do
      before do
        admin_user = users(:admin_user_one)
        sign_in admin_user
      end

      it "returns a successful response with valid params" do
        get :calculate_multiple_finance_line_graph_metrics, params: { excluded_types: ["revenue"] }
        expect(response).to have_http_status(:success)
      end

      it "returns an error with invalid params" do
        get :calculate_multiple_finance_line_graph_metrics, params: { excluded_types: "invalid" }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when user is not an admin" do
      before do
        standard_user = users(:standard_user_one)
        allow(controller).to receive(:current_user).and_return(standard_user)
        sign_in standard_user
      end

      it "denies access" do
        get :calculate_multiple_finance_line_graph_metrics, params: { excluded_types: ["revenue"] }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET #calculate_pipeline_chart_metrics" do
    context "when user is an admin" do
      before do
        admin_user = users(:admin_user_one)
        sign_in admin_user
      end

      it "returns a successful response with valid params" do
        get :calculate_pipeline_chart_metrics, params: { target: "processed" }
        expect(response).to have_http_status(:success)
      end

      it "returns an error with invalid params" do
        get :calculate_pipeline_chart_metrics, params: { target: "add_to_cart" }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when user is not an admin" do
      before do
        standard_user = users(:standard_user_one)
        sign_in standard_user
      end

      it "denies access" do
        valid_target = "revenue"
        get :calculate_pipeline_chart_metrics, params: { target: valid_target }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
