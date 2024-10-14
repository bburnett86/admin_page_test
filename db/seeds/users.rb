# frozen_string_literal: true

def generate_complex_password
  password = ""
  8.times do
    password += "#{('A'..'Z').to_a.sample}#{('a'..'z').to_a.sample}#{('0'..'9').to_a.sample}#{['#', '?', '!', '@', '$', '%', '^', '&', '*', '-'].sample}"
  end
  password[0...8]
end

def generate_name(min_length: 5)
  name = Faker::Name.first_name
  name = Faker::Name.first_name while name.length < min_length
  name
end

def generate_surname(min_length: 5)
  surname = Faker::Name.last_name
  surname = Faker::Name.last_name while surname.length < min_length
  surname
end

# Create 60 standard users
60.times do
  User.create!(
    first_name: generate_name,
    last_name: generate_surname,
    email: Faker::Internet.unique.email,
    password: generate_complex_password,
    role: :standard
  )
end

# Create 30 customer service users
30.times do
  User.create!(
    first_name: generate_name,
    last_name: generate_surname,
    email: Faker::Internet.unique.email,
    password: generate_complex_password,
    role: :customer_service
  )
end

# Create 9 manager users
9.times do
  User.create!(
    first_name: generate_name,
    last_name: generate_surname,
    email: Faker::Internet.unique.email,
    password: generate_complex_password,
    role: :manager
  )
end

# Create 1 admin user
User.create!(
  first_name: "Admin",
  last_name: "User",
  email: "admin@user.com",
  password: "Password1!",
  role: :admin
)

puts "Users seeded"
