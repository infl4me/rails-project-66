# frozen_string_literal: true

require 'rails_helper'

describe 'Auth' do
  let(:auth_hash) do
    {
      provider: 'github',
      uid: '12345',
      info: {
        email: Faker::Internet.email,
        name: Faker::Name.first_name
      },
      credentials: {
        token: Faker::String.random
      }
    }
  end

  it 'signs in user' do
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    post auth_request_path('github')

    follow_redirect!
    expect(response).to redirect_to(root_path)

    user = User.find_by!(email: auth_hash[:info][:email].downcase)

    assert user
    assert signed_in?
  end
end
