# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users
  #Associations
  it { should have_many(:orders) }
  it { should have_many(:assigned_tickets).class_name('Ticket').with_foreign_key('assigned_to') }
  it { should have_many(:created_tickets).class_name('Ticket').with_foreign_key('creator') }
  it { should have_many(:notifications) }

  # Validations
  it { should validate_presence_of(:first_name) }
  it { should validate_length_of(:first_name).is_at_least(3) }
  it { should validate_presence_of(:last_name) }
  it { should validate_length_of(:last_name).is_at_least(3) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should allow_value('email@addresse.foo').for(:email) }
  it { should_not allow_value('email').for(:email) }
  it { should validate_presence_of(:role) }

  # Methods
  describe 'password complexity' do
    it 'is invalid if the password does not meet the complexity requirements' do
      user = User.new(password: '1234')
      user.valid?
      expect(user.errors[:password]).to include('Complexity requirement not met. Length should be 8-30 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character')
    end
  end


  describe '#validate_role' do
    valid_roles = [:admin, :standard, :customer_service, :manager]

    valid_roles.each do |role|
      it "accepts #{role} as a valid role" do
        user = User.new(role: role.to_s)
        user.validate 
        expect(user.errors[:role]).to be_empty
      end
    end

    it 'does not accept an invalid role' do
      expect { User.new(role: 'invalid_role') }.to raise_error(ArgumentError, "'invalid_role' is not a valid role")
    end
  end
end