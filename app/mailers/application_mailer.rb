# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@gh-analyzer'
  layout 'mailer'

  def repository_check_api
    ApplicationContainer[:repository_check_api]
  end
end
