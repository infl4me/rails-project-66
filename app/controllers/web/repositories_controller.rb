# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :set_repository, only: %i[show destroy]

  def index
    authorize Repository

    @repositories = Repository.includes(:last_check)
  end

  def show
    authorize @repository
  end

  def new
    authorize Repository

    @repository = Repository.new
    @repository_options = user_repository_options
  end

  def create
    authorize Repository

    @repository = Repository.new(
      user: current_user,
      original_id: repository_params[:original_id]
    )

    unless @repository.valid?
      @repository_options = user_repository_options
      render :new, status: :unprocessable_entity
      return
    end

    gh_repo = ApplicationContainer[:octokit_client].repository(current_user, @repository.original_id)
    gh_hook = ApplicationContainer[:octokit_client].create_hook(current_user, gh_repo[:id]) unless Rails.configuration._gh_disable_hooks

    @repository.update(
      language: gh_repo[:language].downcase,
      name: gh_repo[:name],
      full_name: gh_repo[:full_name],
      hook_id: gh_hook&.dig(:id)
    )

    if @repository.valid?
      redirect_to repositories_path, notice: t('repositories.notices.created')
    else
      @repository_options = user_repository_options
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @repository

    @repository.destroy!

    begin
      ApplicationContainer[:octokit_client].remove_hook(current_user, @repository) if @repository.hook_id.present?
    rescue Octokit::Error
      Rails.logger.error(e)
      Appsignal.set_error(e)
    end

    redirect_to repositories_url, notice: t('repositories.notices.destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_repository
    @repository = Repository.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def repository_params
    params.require(:repository).permit(:original_id)
  end

  def user_repository_options
    @user_repository_options ||= ApplicationContainer[:octokit_client]
                                 .repositories(current_user)
                                 .filter { |repo| Repository.language.values.include?(repo[:language].downcase) } # rubocop:disable Performance/InefficientHashSearch
                                 .pluck(:name, :id)
  end
end
