# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(repository_check)
    repository_check = CreateRepositoryCheckService.new.call(repository_check)

    RepositoryCheckMailer.with(user: repository_check.repository.user, repository_check:).report_check_result.deliver_now if repository_check.finished? && !repository_check.passed
  end
end
