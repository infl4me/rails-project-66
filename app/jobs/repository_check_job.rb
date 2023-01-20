# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(repository_check)
    CreateRepositoryCheckService.new.call(repository_check)
  end
end
