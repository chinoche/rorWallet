class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    response = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    json_response(data: response)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
