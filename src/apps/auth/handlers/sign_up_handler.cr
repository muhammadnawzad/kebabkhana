module Auth
  class SignUpHandler < Marten::Handlers::Schema
    include RequireAnonymousUser

    schema SignUpSchema
    template_name "auth/sign_up.html"
    success_route_name "auth:profile"

    before_dispatch :redirect_to_signup
    after_successful_schema_validation :sign_up_user

    private def sign_up_user
      new_record = User.new(
        email: schema.email!,
        first_name: schema.first_name!,
        last_name: schema.last_name!,
        team: schema.team!,
        role: "client",
        status: "active",
        balance: 0,
        assigned_focal_point: default_focal_point_based_on_team(schema.team!)
      )
      new_record.set_password(schema.password!)
      new_record.save!

      user = MartenAuth.authenticate(schema.email!, schema.password!)
      MartenAuth.sign_in(request, user.not_nil!) # ameba:disable Lint/NotNil
    end

    private def default_focal_point_based_on_team(team)
      case team
      when "bira", "other"
        "bira_room"
      when "qa", "devops"
        "spaceship"
      else
        "nursery"
      end
    end

    private def redirect_to_signup
      flash[:notice] = "Signing up is currently disabled. If you are a DIT member, please contact the administrator for assistance."
      redirect reverse("auth:sign_in")
    end
  end
end
