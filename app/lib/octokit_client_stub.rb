# frozen_string_literal: true

class OctokitClientStub
  def self.latest_commit_sha(_user, _repository)
    'qqqaaaz'
  end

  def self.repository(_user, _repository_id)
    {
      id: 1,
      name: 'repo1',
      full_name: 'org1/repo1',
      language: 'JavaScript'
    }
  end

  def self.repositories(_user)
    [
      {
        id: 1,
        name: 'repo1',
        full_name: 'org1/repo1',
        language: 'JavaScript'
      },
      {
        id: 2,
        name: 'repo2',
        full_name: 'org1/repo2',
        language: 'Ruby'
      }
    ]
  end

  def self.create_hook(_user, _repository_id)
    {
      id: 1,
      url: Rails.application.routes.url_helpers.api_checks_url,
      content_type: 'json',
      insecure_ssl: 1
    }
  end

  def self.remove_hook(user, repository); end
end
