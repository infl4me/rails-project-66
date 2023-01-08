# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :set_repository, only: %i[show edit update destroy]

  # GET /web/repositories
  def index
    @repositories = Repository.all
  end

  # GET /web/repositories/1
  def show; end

  # GET /web/repositories/new
  def new
    @repository = Repository.new
  end

  # GET /web/repositories/1/edit
  def edit; end

  # POST /web/repositories
  def create
    @repository = Repository.new(repository_params)

    if @repository.save
      redirect_to @repository, notice: 'Repository was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /web/repositories/1
  def update
    if @repository.update(repository_params)
      redirect_to @repository, notice: 'Repository was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /web/repositories/1
  def destroy
    @repository.destroy
    redirect_to repositories_url, notice: 'Repository was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_repository
    @repository = Repository.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def repository_params
    params.require(:repository).permit(:name, :user_id)
  end
end
