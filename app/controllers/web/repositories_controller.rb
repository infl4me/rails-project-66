# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :set_repository, only: %i[show destroy]

  def index
    authorize Repository

    @repositories = Repository.all
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

    client = Octokit::Client.new(access_token: current_user.token)
    gh_repo = client.repo(repository_params[:original_id].to_i)

    @repository = Repository.create(
      user: current_user,
      original_id: gh_repo.id,
      language: gh_repo.language.downcase,
      name: gh_repo.name,
      full_name: gh_repo.full_name
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

    @repository.destroy
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
    client = Octokit::Client.new(access_token: current_user.token)
    client.repos
          .filter { |repo| Repository.language.values.include?(repo['language'].downcase) } # rubocop:disable Performance/InefficientHashSearch
          .pluck(:name, :id)
  end
end
