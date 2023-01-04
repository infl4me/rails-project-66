# frozen_string_literal: true

class HealthcheckController < ApplicationController
  def index
    ActiveRecord::Base.connection.execute('SELECT 1')

    render plain: 'ok'
  end
end
