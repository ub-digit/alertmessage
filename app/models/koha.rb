class Koha
  def self.get_system_preference_mapping name
    # Check if the name is present in the KOHA_SYSTEM_PREFERENCE_MAPPING hash
    if KOHA_SYSTEM_PREFERENCE_MAPPING.key?(name)
      # Return the mapped value
      return KOHA_SYSTEM_PREFERENCE_MAPPING[name]
    else
      # If the name is not found, return nil
      return nil
    end
  end

  def self.get_system_preference_value pref
    # Use Rails.cache to cache the response
    # This will help reduce the number of requests made to the Koha API
    # and improve performance
    # You can adjust the timeout_interval as needed
    timeout_interval = ENV["TIMEOUT_INTERVAL"]
    Rails.cache.fetch(pref, expires_in: timeout_interval.to_i.minutes) do
      url = ENV["KOHA_URL"]
      login_userid = ENV["KOHA_LOGIN_USERID"]
      login_password = ENV["KOHA_LOGIN_PASSWORD"]
      begin
        response = RestClient.get("#{url}?pref=#{pref}&login_userid=#{login_userid}&login_password=#{login_password}")
        handle_response(response)
      rescue RestClient::ExceptionWithResponse => e
        Rails.logger.error("Error from Koha: #{e.message}")  
        nil
      end
    end
  end

  def self.handle_response response
    return nil if response.code != 200
    begin
      # Parse the JSON response
      json_response = JSON.parse(response.body)
      # Check if the response contains the expected structure
      if json_response && json_response["value"]
        # Parse and return the value
        return JSON.parse(json_response["value"])
      else
        return nil
      end
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse JSON response: #{e.message}")
      return nil
    end
  end
end
