# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm column: :state do
    state :running, initial: true
    state :failed, :finished

    event :fail do
      transitions from: :running, to: :failed
    end

    event :finish do
      transitions from: :running, to: :finished
    end
  end

  after_destroy do |repository_check|
    FileUtils.rm_rf(Rails.root.join('tmp/repositories', repository_check.repository.id.to_s, 'checks', repository_check.id.to_s))
  end
end
