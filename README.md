# Rails React Stack

Rails gives us many options when it comes to configuring the frontend of our application, and if you wish you use React as the frontend, [react-rails](https://github.com/reactjs/react-rails) is the easiest way to go about it. This example project has been spun up using react-rails with Rails 7 and the following documentation will outline how you can integrate Playbook into such an app.

## Getting Started

Now we can get started installing and running the application. Carefully review each step below then proceed to the next section.

### Dependencies

1. [Install asdf version manager](https://asdf-vm.com/guide/getting-started.html) (Bash & Git instructions)
1. Run `asdf install` to install dependencies
1. Confirm you are running `ruby` version `3.3.0` by running `ruby -v`
1. Confirm you are running `bundler` version `2.3.14` by running `bundle -v`
1. Confirm you are running `yarn` version `1.22.15` by running `yarn -v`
1. Install gem dependencies `bundle`
1. Install yarn dependencies `yarn`

### Run the Application

1. rails db:create
1. rails db:migrate
1. rails db: seed

1. Create .env files and add proper keys.

1. `yarn watch` will take care of any React component changes
1. `bin/rails s` will start the Rails application
1. Navigate to [localhost:3000](http://localhost:3000)

Check the seed data to login as admin@user.com. If you for whatever reason get a 401 attempting to login with the informaiton available then

rails c
user = User.find_by(email: 'admin@user.com)
user.update(password: "NewSecurePassword1!", password_confirmation: "NewSecurePassword1!")

And attempt to login with new password.

Testing
bundle exec rspec .

