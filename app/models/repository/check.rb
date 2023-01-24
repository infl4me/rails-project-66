# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm do
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
    ApplicationContainer[:repository_check_api].after_destroy_cleanup(repository_check)
  end
end
