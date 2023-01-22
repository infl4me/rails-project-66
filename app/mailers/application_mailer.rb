# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@gh-analyzer'
  layout 'mailer'
end
