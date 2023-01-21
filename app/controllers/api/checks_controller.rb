# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  # github webhook listener
  def create
    return render json: {}, status: :bad_request unless request.headers['X-GitHub-Event'] == 'push'

    repository = Repository.find_by!(original_id: params['repository']['id'])

    RepositoryCheckJob.perform_later(repository.checks.create!)

    render json: {
      pong: params['repository']['name']
    }, status: :ok
  end
end
