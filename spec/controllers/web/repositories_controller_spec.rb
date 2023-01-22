# frozen_string_literal: true

require 'rails_helper'

describe Web::RepositoriesController do
  let(:gh_valid_attributes) do
    repository_attributes = attributes_for(:repository, user: User.first)
    {
      id: repository_attributes[:original_id],
      name: repository_attributes[:name],
      full_name: repository_attributes[:full_name],
      language: repository_attributes[:language]
    }
  end

  let(:gh_invalid_attributes) do
    repository_attributes = attributes_for(:repository, user: User.first)
    {
      id: repository_attributes[:original_id],
      name: repository_attributes[:name],
      full_name: repository_attributes[:full_name],
      language: 'invalid_language'
    }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get :index
      expect(response).to be_successful
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        get :index
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get :show, params: { id: repositories(:repo_one) }
      expect(response).to be_successful
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        get :show, params: { id: repositories(:repo_one) }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get :new
      expect(response).to be_successful
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        get :new
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Repository' do
        expect do
          post :create, params: { repository: { original_id: gh_valid_attributes[:id] } }
        end.to change(Repository, :count).by(1)
        expect(response).to redirect_to(repositories_path)
      end
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        post :create, params: { repository: { original_id: gh_valid_attributes[:id] } }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with invalid parameters' do
      before do
        allow(OctokitClientStub).to receive(:repository).and_return(gh_invalid_attributes)
      end

      it 'does not create a new Repository' do
        expect do
          post :create, params: { repository: { original_id: gh_valid_attributes[:id] } }
        end.not_to change(Repository, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested repository' do
      expect do
        delete :destroy, params: { id: repositories(:repo_one) }
      end.to change(Repository, :count).by(-1)
      expect(response).to redirect_to(repositories_path)
    end

    context 'when guest mode' do
      it 'renders 403 page' do
        sign_out session

        delete :destroy, params: { id: repositories(:repo_one) }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
