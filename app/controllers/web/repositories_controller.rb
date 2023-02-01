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

    github_id = repository_params[:github_id].empty? ? nil : repository_params[:github_id].to_i
    @repository = CreateRepositoryService.new.call(current_user, github_id)

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
      octokit_client.remove_hook(current_user, @repository) if @repository.hook_id.present?
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
    params.require(:repository).permit(:github_id)
  end

  def user_repository_options
    @user_repository_options ||= octokit_client
                                 .repositories(current_user)
                                 .filter { |repo| Repository.language.values.include?(repo[:language]&.downcase) } # rubocop:disable Performance/InefficientHashSearch
                                 .pluck(:name, :id)
  end
end
