require "./concerns/*"

module Auth
  class PasswordResetInitiateHandler < Marten::Handlers::Schema
    include RequireAnonymousUser

    schema PasswordResetInitiateSchema
    template_name "auth/password_reset_initiate.html"
    success_route_name "auth:sign_in"

    after_successful_schema_validation :process_password_reset_request

    private def process_password_reset_request
      flash[:notice] = "We've sent you a recovery e-mail! " +
                       "You will receive instructions by e-mail to reset your password."

      if user = User.get_by_natural_key(self.schema.email!)
        PasswordResetEmail.new(user, request).deliver
      end
    end
  end
end
