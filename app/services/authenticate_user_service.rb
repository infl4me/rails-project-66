# frozen_string_literal: true

class AuthenticateUserService
  def call(data)
    email = data.info.email.downcase
    user = User.find_or_create_by(email:)

    user.update!({
                   nickname: data.info.nickname,
                   token: data.credentials.token
                 })

    user.reload
  end
end
