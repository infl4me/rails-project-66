# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize
  enumerize :language, in: %i[javascript ruby]

  belongs_to :user

  has_many :checks, dependent: :destroy
  after_destroy do |repository|
    ApplicationContainer[:repository_check_api].after_destroy_repository_cleanup(repository)
  end

  has_one :last_check, -> { order 'created_at' }, class_name: 'Repository::Check', inverse_of: :repository, dependent: nil

  validates :github_id, uniqueness: true, presence: true
end
