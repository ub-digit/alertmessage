class HandlerController < ApplicationController
  def show 
    pp params
    name = params[:name]
    if name.present?
      # URL encode the name to ensure it is safe for use in a URL
      name = URI.encode_www_form_component(name)
      # Get the system preference mapping
      pref = Koha.get_system_preference_mapping(name)
      if pref
        # If the mapping is found, get the system preference value
        value = Koha.get_system_preference_value(pref)
        if value
          # If the value is found, return it as JSON
          render json: value, status: :ok
        else
          # If the value is not found, return an error message
          render json: { error: "Value not found for #{name}" }, status: :not_found
        end
      else
        # If the mapping is not found, return an error message
        render json: { error: "Mapping not found for #{name}" }, status: :not_found
      end
    end
  end
end
