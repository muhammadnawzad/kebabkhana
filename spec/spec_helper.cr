ENV["MARTEN_ENV"] = "test"

require "spec"

require "../src/project"
require "marten/spec"
require "marten_auth/spec"

def create_user(username : String, email : String, password : String)
    user = Auth::User.new(email: email, first_name: "John", last_name: "Doe", status: "active", role: "client", balance: 0)
    user.set_password(password)
    user.save!
  
    Profiles::Profile.create!(user: user, username: username)
  
    user
  end
