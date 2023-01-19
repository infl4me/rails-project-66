# frozen_string_literal: true

class OctokitClient
  def self.client(user)
    Octokit::Client.new(access_token: user.token)
  end

  def self.latest_commit_sha(user, repository)
    commit = client(user).commits(repository.original_id).first
    return if commit.nil?

    commit.sha[0..6]
  end
end
