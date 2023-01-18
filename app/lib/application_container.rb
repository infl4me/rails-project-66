# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :docker_exercise_api, -> { RepositoryCheckApiStub }
    # register :octokit_client, -> { OctokitClientStub }
  else
    register :docker_exercise_api, -> { RepositoryCheckApi }
    # register :octokit_client, -> { Octokit::Client }
  end
end
