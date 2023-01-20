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
    storage_root_path(repository_check).join('output.html')
  end

  def self.get_output(repository_check)
    file_path = storage_output_path(repository_check)
    return unless File.exist?(file_path)

    File.read(file_path)
  end

  def self.check(repository_check)
    repository_path = storage_repository_path(repository_check)
    zip_file_path = storage_archive_path(repository_check)
    output_file_path = storage_output_path(repository_check)
    FileUtils.mkdir_p(repository_path)

    download = URI.open("https://api.github.com/repositories/#{repository_check.repository.original_id}/zipball/#{repository_check.commit}")
    IO.copy_stream(download, zip_file_path)

    Zip::File.open(zip_file_path) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(repository_path, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end

    command = if repository_check.repository.language.ruby?
                "bundle exec rubocop -c .rubocop.yml --format html --out #{output_file_path} #{repository_path}"
              elsif repository_check.repository.language.javascript?
                "yarn run eslint --format html -c .eslintrc.json --no-eslintrc #{repository_path} --output-file #{output_file_path}"
              else
                raise 'invalid language value'
              end

    exit_status = Open3.popen3(command) { |_stdin, _stdout, _stderr, wait_thr| wait_thr.value.exitstatus }

    exit_status.zero?
  ensure
    FileUtils.rm_rf(repository_path) unless repository_path.nil?
    FileUtils.rm_rf(zip_file_path) unless zip_file_path.nil?
  end

  def self.after_destroy_repository_cleanup(repository)
    FileUtils.rm_rf(storage_repository_root_path(repository))
  end

  def self.after_destroy_cleanup(repository_check)
    FileUtils.rm_rf(storage_root_path(repository_check))
  end
end
