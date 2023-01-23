# frozen_string_literal: true

class RepositoryCheckMailer < ApplicationMailer
  def report_check_result
    @user = params[:user]
    @repository_check = params[:repository_check]
    @check_output = ApplicationContainer[:repository_check_api].get_output(@repository_check)

    mail(
      to: @user.email,
      subject: t('repository_check_mailer.report_check_result.title', name: @repository_check.repository.full_name)
    )
  end
end
