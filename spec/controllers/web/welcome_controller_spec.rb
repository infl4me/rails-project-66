# frozen_string_literal: true

require 'rails_helper'

describe Web::WelcomeController do
  describe '#index' do
    subject(:index) { get :index }

    it 'renders page' do
      index

      expect(response).to be_successful
    end
  end
end
