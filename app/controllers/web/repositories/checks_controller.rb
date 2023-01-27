# frozen_string_literal: true

require 'json'

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  before_action :set_repository_check, only: %i[show output]

  def show
    authorize @repository_check

    @check_output_exist = File.exist? repository_check_api.storage_output_path(@repository_check)
  end

  def output
    authorize @repository_check

    render inline: repository_check_api.get_output(@repository_check) # rubocop:disable Rails/RenderInline
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
