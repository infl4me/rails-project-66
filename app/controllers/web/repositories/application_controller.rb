# frozen_string_literal: true

class Web::Repositories::ApplicationController < Web::ApplicationController
  helper_method :resource_repository

  def resource_repository
    @resource_repository ||= Repository.find(params[:repository_id])
  end
end
