module Auth
  class SignInHandler < Marten::Handlers::Schema
    include RequireAnonymousUser

    schema SignInSchema
    template_name "auth/sign_in.html"
    success_route_name "auth:profile"

    after_successful_schema_validation :sign_in_user

    private def sign_in_user
      MartenAuth.sign_in(request, schema.user.not_nil!) # ameba:disable Lint/NotNil
    end
  end
end
