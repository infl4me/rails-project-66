# frozen_string_literal: true

require 'json'

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  before_action :set_repository_check, only: %i[show]

  def show
    authorize @repository_check

    @check_output = ApplicationContainer[:repository_check_api].get_output(@repository_check) unless @repository_check.check_passed
  end

  def create
    repository_check = resource_repository.checks.build
    authorize repository_check

    repository_check.save!

    RepositoryCheckJob.perform_later(repository_check)

    redirect_to repository_check_path(resource_repository, repository_check), notice: t('repository_checks.notices.started')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_repository_check
    @repository_check = Repository::Check.find(params[:id])
  end
end
