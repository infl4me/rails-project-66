# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, dependent: :destroy

  enumerize :language, in: %i[javascript]

  validates :original_id, uniqueness: true

  after_destroy do |repository|
    FileUtils.rm_rf(Rails.root.join('tmp/repositories', repository.id.to_s))
  end
end