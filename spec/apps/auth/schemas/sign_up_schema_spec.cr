require "./spec_helper"

describe Auth::SignUpSchema do
  describe "#valid?" do
    it "returns true if the email is valid and the provided passwords are the same" do
      schema = Auth::SignUpSchema.new(
        Marten::HTTP::Params::Data{
          "first_name" => ["Test"],
          "last_name" => ["User"],
          "role" => ["client"],
          "status" => ["active"],
          "balance" => ["0"],
          "email"     => ["test@example.com"],
          "password" => ["insecure"],
          "password_confirmation" => ["insecure"],
        }
      )
      schema.valid?.should be_true
      schema.errors.should be_empty
    end

    it "returns false if the data is not provided" do
      schema = Auth::SignUpSchema.new(
        Marten::HTTP::Params::Data{"email" => [""], "password" => [""], "password_confirmation" => [""], "first_name" => [""], "last_name" => [""]}
      )

      schema.valid?.should be_false

      schema.errors.size.should eq 5
      schema.errors[0].field.should eq "first_name"
      schema.errors[0].type.should eq "required"
      schema.errors[1].field.should eq "last_name"
      schema.errors[1].type.should eq "required"
      schema.errors[2].field.should eq "email"
      schema.errors[2].type.should eq "required"
      schema.errors[3].field.should eq "password"
      schema.errors[3].type.should eq "required"
      schema.errors[4].field.should eq "password_confirmation"
      schema.errors[4].type.should eq "required"
    end

    it "returns false if the email address is already taken" do
      create_user(email: "test@example.com", password: "insecure")

      schema = Auth::SignUpSchema.new(
        Marten::HTTP::Params::Data{
          "first_name" => ["Test"],
          "last_name" => ["User"],
          "email"     => ["test@example.com"],
          "password" => ["insecure"],
          "password_confirmation" => ["insecure"],
        }
      )

      schema.valid?.should be_false

      schema.errors.size.should eq 1
      schema.errors[0].field.should eq "email"
      schema.errors[0].message.should eq "This email address is already taken"
    end

    it "returns false if the email address is already taken in a case insensitive way" do
      create_user(email: "test@example.com", password: "insecure")

      schema = Auth::SignUpSchema.new(
        Marten::HTTP::Params::Data{
          "first_name" => ["Test"],
          "last_name" => ["User"],
          "email"     => ["TesT@ExamPLE.com"],
          "password" => ["insecure"],
          "password_confirmation" => ["insecure"],
        }
      )

      schema.valid?.should be_false

      schema.errors.size.should eq 1
      schema.errors[0].field.should eq "email"
      schema.errors[0].message.should eq "This email address is already taken"
    end

    it "returns false if the two password values do not match" do
      schema = Auth::SignUpSchema.new(
        Marten::HTTP::Params::Data{
          "first_name" => ["Test"],
          "last_name" => ["User"],
          "email"     => ["test@example.com"],
          "password" => ["insecure"],
          "password_confirmation" => ["other"],
        }
      )

      schema.valid?.should be_false

      schema.errors.size.should eq 1
      schema.errors[0].field.should be_nil
      schema.errors[0].message.should eq "The two password fields do not match"
    end
  end
end
