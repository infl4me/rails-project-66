# frozen_string_literal: true

class RepositoryCheckApi
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

  def self.get_output(repository_check)
    file_path = RepositoryCheckApi.storage_output_path(repository_check)
    return unless File.exist?(file_path)

    JSON.pretty_generate(JSON.parse(File.read(file_path)))
  end
end
