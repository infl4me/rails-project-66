# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    user = AuthenticateUserService.new.call(request.env['omniauth.auth'][:info])
    sign_in user

    redirect_to root_path
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
