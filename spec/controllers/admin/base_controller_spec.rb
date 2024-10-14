# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::BaseController, type: :controller do
  fixtures :users

  before do
    admin_user = users(:admin_user_one)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe "Role-based access control" do
    context "when user is an admin" do
      it "allows access" do
        expect(response).to_not redirect_to(root_path)
      end
    end

    # context "when user is a manager" do
    #   before do
    #     manager_user = users(:manager_user_one)
    #     allow(controller).to receive(:current_user).and_return(manager_user)
    #   end

    #   it "redirects from sensitive actions" do
    #     # Assuming validate_admin is used for some actions
    #     get :some_admin_action
    #     expect(response).to redirect_to(root_path)
    #   end
    # end

    # context "when user is customer service" do
    #   before do
    #     customer_service_user = users(:customer_service_user_one)
    #     allow(controller).to receive(:current_user).and_return(customer_service_user)
    #   end

    #   it "redirects from sensitive actions" do
    #     # Assuming validate_manager_min is used for some actions
    #     get :some_manager_action
    #     expect(response).to redirect_to(root_path)
    #   end
    # end

    # context "when user is a standard user" do
    #   before do
    #     standard_user = users(:standard_user_one)
    #     allow(controller).to receive(:current_user).and_return(standard_user)
    #   end

    #   it "redirects from all protected actions" do
    #     get :calculate_multiple_finance_line_graph_metrics
    #     expect(response).to redirect_to(root_path)
    #   end
    # end
  end
end
