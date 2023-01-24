# frozen_string_literal: true

require 'rails_helper'

describe Web::Repositories::ChecksController do
  include ActiveJob::TestHelper

  describe 'GET /show' do
    let(:repository_check) { repository_checks(:repository_check_one) }

    it 'renders a successful response' do
      get :show, params: { id: repository_check, repository_id: repository_check.repository }
      expect(response).to be_successful
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        get :show, params: { id: repository_check, repository_id: repository_check.repository }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /create' do
    let(:repository) { repositories(:repo_one) }

    it 'creates a new Repository Check' do
      expect do
        post :create, params: { repository_id: repository }
      end.to change(Repository::Check, :count).by(1)

      perform_enqueued_jobs

      expect(Repository::Check.last.aasm_state).to eq('finished')

      expect(response).to redirect_to(repository_check_path(repository, Repository::Check.last))
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        post :create, params: { repository_id: repository }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
