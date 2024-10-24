# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::TicketAnalyticsController, type: :controller do
  fixtures :users, :tickets

  describe "GET #sorted_tickets_by_status" do
    context "when user is an admin" do
      before do
        admin_user = users(:admin_user_one)
        sign_in admin_user
      end
  
      it "returns a successful response with valid params" do
        get :sorted_tickets_by_status, params: { status: "manager_feedback", timeframe: 30 }
        expect(response).to have_http_status(:success)
      end
  
      it "returns an error with invalid params" do
        get :sorted_tickets_by_status, params: { status: "invalid_status" }
        expect(response).to have_http_status(:bad_request)
      end
    end
  
    context "when user is not an admin" do
      before do
        standard_user = users(:standard_user_one)
        sign_in standard_user
      end
  
      it "denies access" do
        get :sorted_tickets_by_status, params: { status: "new_ticket", timeframe: 30 }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

    describe "GET #calculate_ticket_totals" do
    context "when user is an admin" do
      before do
        admin_user = users(:admin_user_one)
        sign_in admin_user
      end
  
      it "returns a successful response with valid params" do
        get :calculate_ticket_totals, params: { timeframe: 6 }
        expect(response).to have_http_status(:success)
      end
  
      it "returns a 400 response when timeframe is less than or equal to 5" do
        get :calculate_ticket_totals, params: { timeframe: 5 }
        expect(response).to have_http_status(:bad_request)
      end
  
      it "returns a 400 response when timeframe is greater than or equal to 13" do
        get :calculate_ticket_totals, params: { timeframe: 13 }
        expect(response).to have_http_status(:bad_request)
      end
  
      it "returns an error with invalid params" do
        get :calculate_ticket_totals, params: { timeframe: "invalid" }
        expect(response).to have_http_status(:bad_request)
      end
  
      it "returns a successful response with valid params and timeframe 12" do
        get :calculate_ticket_totals, params: { timeframe: 12 }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          "closed_without_feedback" => 1,
          "escalated" => 5,
          "overdue" => 0,
          "total" => 6
        )
      end
    end
  
    context "when user is not an admin" do
      before do
        standard_user = users(:standard_user_one)
        sign_in standard_user
      end
  
      it "denies access" do
        get :calculate_ticket_totals, params: { timeframe: 30 }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
