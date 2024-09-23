module Auth
  class User < MartenAuth::User
    field :first_name, :string, max_size: 128
    field :last_name, :string, max_size: 128

    def full_name
      "#{first_name} #{last_name}"
    end
  end
end
