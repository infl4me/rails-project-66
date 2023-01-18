# frozen_string_literal: true

require 'open-uri'
require 'open3'
require 'zip'

class CreateRepositoryCheckService
  def call(user, repository)
    client = Octokit::Client.new(access_token: user.token)
    latest_commit = client.commits(repository.original_id).first

    repository_check = Repository::Check.create!(repository:, commit: latest_commit.sha[0..6])

    repository_path = RepositoryCheckApi.storage_repository_path(repository_check)
    zip_file_path = RepositoryCheckApi.storage_archive_path(repository_check)
    output_file_path = RepositoryCheckApi.storage_output_path(repository_check)
    FileUtils.mkdir_p(repository_path)

    download = URI.open("https://api.github.com/repositories/#{repository.original_id}/zipball/#{repository_check.commit}")
    IO.copy_stream(download, zip_file_path)

    Zip::File.open(zip_file_path) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(repository_path, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end

    exit_status = Open3.popen3("yarn run eslint --format json -c .eslintrc.json --no-eslintrc #{repository_path} --output-file #{output_file_path}") { |_stdin, _stdout, _stderr, wait_thr| wait_thr.value.exitstatus }

    repository_check.update!(check_passed: exit_status.zero?)

    repository_check.finish!
    repository_check
  rescue StandardError => e
    repository_check.fail!
    raise e
  ensure
    FileUtils.rm_rf(repository_path) unless repository_path.nil?
    FileUtils.rm_rf(zip_file_path) unless zip_file_path.nil?
  end
end
