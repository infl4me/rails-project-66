# frozen_string_literal: true

class CreateRepositoryService
  def call(user, github_id)
    repository = Repository.new(
      user:,
      github_id:
    )

    return repository unless repository.valid?

    gh_repo = ApplicationContainer[:octokit_client].repository(user, repository.github_id)
    gh_hook = ApplicationContainer[:octokit_client].create_hook(user, gh_repo[:id]) unless Rails.configuration._gh_disable_hooks

    repository.update(
      language: gh_repo[:language].downcase,
      name: gh_repo[:name],
      full_name: gh_repo[:full_name],
      hook_id: gh_hook&.dig(:id)
    )

    repository
  end
end
