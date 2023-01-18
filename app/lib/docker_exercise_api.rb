# frozen_string_literal: true

class DockerExerciseApi
  def self.repo_dest(lang_name)
    "/tmp/#{image_name(lang_name)}"
  end

  def self.image_name(lang_name)
    "hexletbasics/exercises-#{lang_name}"
  end

  def self.download(lang_name)
    stdout, exit_status = Open3.popen3('') { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }

    exit_status.exitstatus # https://docs.ruby-lang.org/en/2.0.0/Process/Status.html#method-i-exitstatus
    puts stdout # вывод stdout
  end

  def self.run_exercise(created_code_file_path:, exercise_file_path:, docker_image:, image_tag:, path_to_code:)
    volume = "-v #{created_code_file_path}:#{exercise_file_path}"
    command = "docker run --rm  --memory=512m --net none #{volume} #{docker_image}:#{image_tag} timeout 6 make --silent -C #{path_to_code} test"
    Rails.logger.debug(command)

    output = []
    status = BashRunner.start(command) { |line| output << line }

    [output.join, status]
  end

  def self.tag_image_version(lang_name, tag)
    return unless Rails.env.production?

    tag_command = "docker tag #{image_name(lang_name)}:latest #{image_name(lang_name)}:#{tag}"
    BashRunner.start(tag_command)

    push_command = "docker push #{image_name(lang_name)}:#{tag}"
    ok = BashRunner.start(push_command)

    raise "Docker tag error: #{ok}" unless ok
  end

  def self.remove_image(lang_name, tag)
    remove_command = "docker rmi #{image_name(lang_name)}:#{tag}"
    _ok = BashRunner.start(remove_command)
  end
end
