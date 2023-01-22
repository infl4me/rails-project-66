# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(repository_check)
    repository_check = CreateRepositoryCheckService.new.call(repository_check)

    if repository_check.finished? && !repository_check.check_passed
      RepositoryCheckMailer.with(user: repository_check.repository.user, repository_check:).report_check_result.deliver_now
    end
  end
end
