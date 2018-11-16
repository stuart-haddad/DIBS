class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :default_headers

  #http_basic_authenticate_with name: ENV["BASIC_AUTH_USER_NAME"], password: ENV["BASIC_AUTH_PASSWORD"]

  rescue_from Google::Apis::AuthorizationError, Google::Apis::ClientError do
    redirect_to authorize_url
  end

  def default_headers
	  headers['X-Frame-Options'] = 'allow-from https://signage.screen.cloud'
	end
end
