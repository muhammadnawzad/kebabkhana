require "marten_auth/spec"

require "../../spec_helper"

def create_user(email : String, password : String)
  user = Auth::User.new(email: email, first_name: "John", last_name: "Doe", status: "active", role: "client", balance: 0)
  user.set_password(password)
  user.save!

  user
end
