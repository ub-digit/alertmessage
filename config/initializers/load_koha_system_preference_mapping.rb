if ENV["KOHA_SYSTEM_PREFERENCE_MAPPING"].blank?
  raise "KOHA_SYSTEM_PREFERENCE_MAPPING is not set. Please set it in your environment variables."
end
# Load the system preference mapping from the environment variable
KOHA_SYSTEM_PREFERENCE_MAPPING = ENV["KOHA_SYSTEM_PREFERENCE_MAPPING"].split(",").map { |i| i.split(":") }.to_h
