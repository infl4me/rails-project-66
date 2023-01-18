# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :docker_exercise_api, -> { DockerExerciseApiStub }
    register :octokit_client, -> { OctokitClientStub }
  else
    register :docker_exercise_api, -> { DockerExerciseApi }
    register :octokit_client, -> { Octokit::Client }
  end
end
