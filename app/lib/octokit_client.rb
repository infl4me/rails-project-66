# frozen_string_literal: true

class OctokitClient
  def self.client(user)
    client = Octokit::Client.new(access_token: user.token)
    client.auto_paginate = true
    client
  end

  def self.latest_commit_sha(user, repository)
    commit = client(user).commits(repository.github_id).first
    return if commit.nil?

    commit.sha[0..6]
  end

  def self.repository(user, repository_id)
    client(user).repo(repository_id)
  end

  def self.repositories(user)
    client(user).repos
  end

  def self.create_hook(user, repository_id)
    client(user).create_hook(
      repository_id,
      'web',
      {
        url: Rails.application.routes.url_helpers.api_checks_url,
        content_type: 'json',
        insecure_ssl: 1
      }
    )
  end

  def self.remove_hook(user, repository)
    client(user).remove_hook(repository.github_id, repository.hook_id)
  end
end
