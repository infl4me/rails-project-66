# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  attr_reader :user, :repository_check

  def initialize(user, repository_check)
    super
    @user = user
    @repository_check = repository_check
  end

  def show?
    @user.present? && @user == @repository_check.repository.user
  end

  def create?
    @user.present? && @user == @repository_check.repository.user
  end

  def output?
    show?
  end
end
