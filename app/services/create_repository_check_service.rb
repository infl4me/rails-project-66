# frozen_string_literal: true

require 'open-uri'
require 'open3'
require 'zip'

class CreateRepositoryCheckService
  def call(user, repository)
    latest_commit_sha = ApplicationContainer[:octokit_client].latest_commit_sha(user, repository)

    repository_check = Repository::Check.create!(repository:, commit: latest_commit_sha)

    check_passed = ApplicationContainer[:repository_check_api].check(repository_check)

    repository_check.update!(check_passed:)

    repository_check.finish!
    repository_check
  rescue StandardError => e
    Rails.logger.error e
    Appsignal.set_error(e)

    repository_check.fail!
    repository_check
  end
end
