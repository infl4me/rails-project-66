# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    user = AuthenticateUserService.new.call(request.env['omniauth.auth'])
    sign_in user

    redirect_to root_path
  end

  def failure
    # TODO: Add flash error
    redirect_to root_path
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end