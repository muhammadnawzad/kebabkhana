require "./spec_helper"

describe Auth::SignUpHandler do
  describe "#get" do
    it "redirects to the profile page if the user is already authenticated" do
      user = create_user(email: "test@dit.gov.krd", password: "insecure")

      url = Marten.routes.reverse("auth:sign_up")

      Marten::Spec.client.sign_in(user)
      response = Marten::Spec.client.get(url)

      response.status.should eq 302
      response.headers["Location"].should eq Marten.routes.reverse("landing")
    end

    it "renders the form as expected for anonymous users" do
      url = Marten.routes.reverse("auth:sign_up")
      response = Marten::Spec.client.get(url)

      response.status.should eq 200
      response.content.includes?("Sign up").should be_true
    end
  end

  describe "#post" do
    it "renders the form if the form data is invalid" do
      url = Marten.routes.reverse("auth:sign_up")
      response = Marten::Spec.client.post(url, data: {"email": "", "password": "", "password_confirmation": ""})

      response.status.should eq 422
      response.content.includes?("Sign up").should be_true
    end

    it "signs in the new user and redirects as expected if the is valid" do
      url = Marten.routes.reverse("auth:sign_up")
      response = Marten::Spec.client.post(
        url,
        data: {
          "email":                 "test@dit.gov.krd",
          "password":              "insecure",
          "password_confirmation": "insecure",
          "first_name":            "Test",
          "last_name":             "User",
          "role":                  "client",
          "status":                "active",
          "balance":               0,
          "team":                  "dev",
          "assigned_focal_point":  "spaceship",
        }
      )

      response.status.should eq 302
      response.headers["Location"].should eq Marten.routes.reverse("auth:profile")
      Marten::Spec.client.get(Marten.routes.reverse("auth:profile")).status.should eq 200
    end
  end
end
