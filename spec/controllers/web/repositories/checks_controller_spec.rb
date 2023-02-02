# frozen_string_literal: true

require 'rails_helper'

describe Web::Repositories::ChecksController do
  include ActiveJob::TestHelper

  describe 'GET /show' do
    subject(:show) { get :show, params: { id: repository_check, repository_id: repository_check.repository } }

    let(:repository_check) { repository_checks(:repository_check_one) }

    it 'renders a successful response' do
      show
      expect(response).to be_successful
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        show

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST /create' do
    subject(:create) { post :create, params: { repository_id: repository } }

    let(:repository) { repositories(:repo_one) }

    it 'creates a new Repository Check' do
      expect { create }.to change(Repository::Check, :count).by(1)
      expect(response).to redirect_to(repository_check_path(repository, Repository::Check.last))

      perform_enqueued_jobs

      expect(Repository::Check.last.aasm_state).to eq('finished')
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        create

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
