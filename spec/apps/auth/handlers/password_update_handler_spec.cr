require "./spec_helper"

describe Auth::PasswordUpdateHandler do
  describe "#get" do
    it "redirects to the sign in page if the user is not authenticated" do
      url = Marten.routes.reverse("auth:password_update")

      response = Marten::Spec.client.get(url)

      response.status.should eq 302
      response.headers["Location"].should eq Marten.routes.reverse("auth:sign_in")
    end

    it "shows the update password page of the authenticated user" do
      user = create_user(email: "test@dit.gov.krd", password: "insecure")

      url = Marten.routes.reverse("auth:password_update")

      Marten::Spec.client.sign_in(user)
      response = Marten::Spec.client.get(url)

      response.status.should eq 200
      response.content.includes?("Update your password").should be_true
    end
  end

  describe "#post" do
    it "redirects to the sign in page if the user is not authenticated" do
      create_user(email: "test@dit.gov.krd", password: "insecure")

      url = Marten.routes.reverse("auth:password_update")

      response = Marten::Spec.client.post(url, data: {
        "old_password":         "insecure",
        "new_password":         "newinsecure",
        "new_confirm_password": "newinsecure",
      })

      response.status.should eq 302
      response.headers["Location"].should eq Marten.routes.reverse("auth:sign_in")
    end

    it "redirects to the profile page after successfully updating the current users password" do
      user = create_user(email: "test@dit.gov.krd", password: "insecure")

      url = Marten.routes.reverse("auth:password_update")

      Marten::Spec.client.sign_in(user)

      response = Marten::Spec.client.post(url, data: {
        "old_password":         "insecure",
        "new_password":         "newinsecure",
        "new_confirm_password": "newinsecure",
      })

      response.status.should eq 302
      response.headers["Location"].should eq Marten.routes.reverse("auth:profile")

      user.reload.check_password("newinsecure").should be_true
    end

    it "renders the form if the form data is invalid" do
      user = create_user(email: "test@dit.gov.krd", password: "insecure")

      url = Marten.routes.reverse("auth:password_update")

      Marten::Spec.client.sign_in(user)

      response = Marten::Spec.client.post(url, data: {
        "old_password":         "",
        "new_password":         "",
        "new_confirm_password": "",
      })

      response.status.should eq 422
      response.content.includes?("Update your password").should be_true
    end
  end
end
