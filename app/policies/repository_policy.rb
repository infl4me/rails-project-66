# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  attr_reader :user, :repository

  def initialize(user, repository)
    super
    @user = user
    @repository = repository
  end

  def index?
    @user.present?
  end

  def show?
    @user == @repository.user
  end

  def create?
    @user.present?
  end

  def new?
    create?
  end

  def update?
    @user == @repository.user
  end

  def edit?
    update?
  end

  def destroy?
    @user == @repository.user
  end
end
