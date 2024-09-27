module Auth
  class SignUpHandler < Marten::Handlers::Schema
    include RequireAnonymousUser

    schema SignUpSchema
    template_name "auth/sign_up.html"
    success_route_name "auth:profile"

    after_successful_schema_validation :sign_up_user

    private def sign_up_user
      new_record = User.new(email: schema.email!, first_name: schema.first_name!, last_name: schema.last_name!, role: "client", status: "active", balance: 0)
      new_record.set_password(schema.password1!)
      new_record.save!

      user = MartenAuth.authenticate(schema.email!, schema.password1!)
      MartenAuth.sign_in(request, user.not_nil!) # ameba:disable Lint/NotNil
    end
  end
end
