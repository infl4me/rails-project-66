# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  # github webhook listener
  def create
    repository = Repository.find_by!(github_id: params['repository']['id'])

    RepositoryCheckJob.perform_later(repository.checks.create!)

    render json: {
      pong: params['repository']['name']
    }, status: :ok
  end
end
