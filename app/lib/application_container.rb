# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repository_check_api, -> { RepositoryCheckApiStub }
    register :octokit_client, -> { OctokitClientStub }
  else
    register :repository_check_api, -> { RepositoryCheckApi }
    register :octokit_client, -> { OctokitClient }
  end
end
