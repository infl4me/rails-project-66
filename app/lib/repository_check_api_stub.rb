# frozen_string_literal: true

class RepositoryCheckApiStub
  def self.storage_repository_root_path(repository)
    Rails.root.join('tmp', 'repositories', repository.id.to_s)
  end

  def self.storage_root_path(repository_check)
    storage_repository_root_path(repository_check.repository).join('checks', repository_check.id.to_s)
  end

  def self.storage_repository_path(repository_check)
    storage_root_path(repository_check).join('repository')
  end

  def self.storage_archive_path(repository_check)
    storage_root_path(repository_check).join('archive.zip')
  end

  def self.storage_output_path(repository_check)
    storage_root_path(repository_check).join('output.json')
  end

  def self.get_output(_repository_check)
    {
      'asd' => 'qwe',
      'qwe' => 'asd'
    }
  end

  def self.check(_repository_check)
    false
  end

  def self.after_destroy_repository_cleanup(repository); end

  def self.after_destroy_cleanup(repository_check); end
end
