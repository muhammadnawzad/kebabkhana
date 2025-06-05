require "digest/sha256"

class Auth::OTPService
  property base_url : String = ""
  property locale : String = "en"
  property remote_response : JSON::Any = JSON::Any.new({} of String => JSON::Any)

  def initialize(locale : String = "en")
    @base_url = ENV.fetch("KEBABKHANA__OTP__BASE_URL", "")
    @locale = locale
  end

  def send_otp(state : String, phone_number : String) : String
    Log.info { "Sending OTP to #{phone_number}" }
    response = HTTP::Client.post(
      @base_url,
      headers: HTTP::Headers{
        "Content-Type" => "application/json",
        "X-Api-Key" => ENV.fetch("KEBABKHANA__OTP__API_KEY", "")
      },
      body: {
        to: "+964#{phone_number}",
        locale: @locale,
        externalId: Digest::SHA256.hexdigest(state),
        serviceId: ENV.fetch("KEBABKHANA__OTP__SERVICE_ID", "")
      }.to_json
    )

    @remote_response = JSON.parse(response.body)
    Log.info { "OTP response: #{@remote_response}" }

    if response.status_code == 200 && @remote_response["id"]?
      return @remote_response["id"].to_s
    elsif response.status_code == 429
      Log.error { "Rate limit exceeded" }
      raise "Rate limit exceeded"
    else
      Log.error { "Failed to send OTP" }
      raise "Failed to send OTP"
    end
  end

  def verify_otp(challenge_id : String, otp : String) : Bool
    response = HTTP::Client.post(
      "#{@base_url}/#{challenge_id}/verify",
      headers: HTTP::Headers{
        "Content-Type" => "application/json",
        "X-Api-Key" => ENV.fetch("KEBABKHANA__OTP__API_KEY", "")
      },
      body: {
        code: otp
      }.to_json
    )
    
    Log.info { "OTP verification response: #{response}" }
    Log.info { "OTP verification response: #{response.status_code}" }

    if response.status_code == 204
      return true
    else
      return false
    end
  end
end
