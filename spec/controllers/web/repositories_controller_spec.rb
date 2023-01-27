# frozen_string_literal: true

require 'rails_helper'

describe Web::RepositoriesController do
  describe 'GET /index' do
    subject(:index) { get :index }

    it 'renders a successful response' do
      index

      expect(response).to be_successful
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        index

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /show' do
    subject(:show) { get :show, params: { id: repositories(:repo_one) } }

    it 'renders a successful response' do
      show

      expect(response).to be_successful
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        show

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /new' do
    subject(:get_new) { get :new }

    it 'renders a successful response' do
      get_new

      expect(response).to be_successful
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        get_new

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /create' do
    subject(:create) { post :create, params: { repository: { github_id: } } }

    let(:github_id) { attributes_for(:repository, user: User.first)[:github_id] }

    context 'with valid parameters' do
      it 'creates a new Repository' do
        expect { create }.to change(Repository, :count).by(1)

        expect(response).to redirect_to(repositories_path)
      end
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        create

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with invalid parameters' do
      let(:gh_invalid_attributes) do
        repository_attributes = attributes_for(:repository, user: User.first)
        {
          id: repository_attributes[:github_id],
          name: repository_attributes[:name],
          full_name: repository_attributes[:full_name],
          language: 'invalid_language'
        }
      end

      before do
        allow(OctokitClientStub).to receive(:repository).and_return(gh_invalid_attributes)
      end

      it 'does not create a new Repository' do
        expect { create }.not_to change(Repository, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    subject(:destroy) { delete :destroy, params: { id: repositories(:repo_one) } }

    it 'destroys the requested repository' do
      expect { destroy }.to change(Repository, :count).by(-1)
      expect(response).to redirect_to(repositories_path)
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        destroy

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
