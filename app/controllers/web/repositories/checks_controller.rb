# frozen_string_literal: true

require 'open-uri'
require 'open3'
require 'zip'
require 'json'

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  before_action :set_repository_check, only: %i[show]

  def index
    @repositories = Repository.all
  end

  def show
    destination_path = destination_path(resource_repository, @repository_check)
    data = File.read(destination_path.join('result.json'))
    @check_output = JSON.pretty_generate(JSON.parse(data)) unless @repository_check.check_passed
  end

  def create
    client = Octokit::Client.new(access_token: current_user.token)
    latest_commit = client.commits(resource_repository.original_id).first

    repository_check = Repository::Check.create!(repository: resource_repository, commit: latest_commit.sha[0..6])

    begin
      destination_path = destination_path(resource_repository, repository_check)
      repository_path = destination_path.join('repository')
      FileUtils.mkdir_p(repository_path)

      download = URI.open("https://api.github.com/repositories/#{resource_repository.original_id}/zipball/#{repository_check.commit}")
      zip_file_path = Rails.root.join(destination_path, 'archive.zip')
      IO.copy_stream(download, zip_file_path)

      Zip::File.open(zip_file_path) do |zip_file|
        zip_file.each do |f|
          fpath = File.join(repository_path, f.name)
          zip_file.extract(f, fpath) unless File.exist?(fpath)
        end
      end

      exit_status = Open3.popen3("yarn run eslint --format json -c .eslintrc.json --no-eslintrc #{repository_path} --output-file #{destination_path.join('result.json')}") { |_stdin, _stdout, _stderr, wait_thr| wait_thr.value.exitstatus }

      repository_check.update!(check_passed: exit_status.zero?)

      repository_check.finish!
    rescue StandardError => e
      repository_check.fail!
      raise e
    ensure
      FileUtils.rm_rf(zip_file_path) unless zip_file_path.nil?
      FileUtils.rm_rf(repository_path) unless repository_path.nil?
    end

    redirect_to repository_check_path(resource_repository, repository_check), notice: 'Repository check finished'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_repository_check
    @repository_check = Repository::Check.find(params[:id])
  end

  def destination_path(repository, repository_check)
    Rails.root.join('tmp/repositories', repository.id.to_s, 'checks', repository_check.id.to_s)
  end
end
