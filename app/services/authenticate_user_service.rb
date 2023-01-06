# frozen_string_literal: true

class AuthenticateUserService
  def call(info)
    email = info.email.downcase
    user = User.find_or_create_by(email:)

    user.update({
                  nickname: info.nickname,
                  name: info.name,
                  image_url: info.image,
                  token: info.token
                })
  end
end
