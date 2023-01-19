# frozen_string_literal: true

require 'json'

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  before_action :set_repository_check, only: %i[show]

  def show
    authorize @repository_check

    @check_output = ApplicationContainer[:repository_check_api].get_output(@repository_check) unless @repository_check.check_passed
  end

  def create
    authorize resource_repository.checks.build

    repository_check = CreateRepositoryCheckService.new.call(current_user, resource_repository)

    redirect_to repository_check_path(resource_repository, repository_check), notice: t('repository_checks.notices.created')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_repository_check
    @repository_check = Repository::Check.find(params[:id])
  end
end
