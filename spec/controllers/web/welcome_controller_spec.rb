# frozen_string_literal: true

require 'rails_helper'

describe Web::WelcomeController do
  describe '#index' do
    it 'renders page' do
      get :index

      expect(response).to be_successful
    end
  end
end
