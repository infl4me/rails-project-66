# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :handle_access_denied

  def repository_check_api
    ApplicationContainer[:repository_check_api]
  end
end
