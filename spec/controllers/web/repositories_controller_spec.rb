# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

describe Web::RepositoriesController do
  # This should return the minimal set of attributes required to create a valid
  # Repository. As you add validations to Repository, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Repository.create! valid_attributes
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      repository = Repository.create! valid_attributes
      get repository_path(repository)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      repository = Repository.create! valid_attributes
      get :edit, params: { repository: }
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Repository' do
        expect do
          post repositories_path, params: { repository: valid_attributes }
        end.to change(Repository, :count).by(1)
      end

      it 'redirects to the created repository' do
        post repositories_path, params: { repository: valid_attributes }
        expect(response).to redirect_to(repository_path(Repository.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Repository' do
        expect do
          post repositories_path, params: { repository: invalid_attributes }
        end.not_to change(Repository, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post repositories_path, params: { repository: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested repository' do
        repository = Repository.create! valid_attributes
        patch repository_path(repository), params: { repository: new_attributes }
        repository.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the repository' do
        repository = Repository.create! valid_attributes
        patch repository_path(repository), params: { repository: new_attributes }
        repository.reload
        expect(response).to redirect_to(repository_path(repository))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        repository = Repository.create! valid_attributes
        patch repository_path(repository), params: { repository: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested repository' do
      repository = Repository.create! valid_attributes
      expect do
        delete repository_path(repository)
      end.to change(Repository, :count).by(-1)
    end

    it 'redirects to the repositories list' do
      repository = Repository.create! valid_attributes
      delete repository_path(repository)
      expect(response).to redirect_to(repositories_path)
    end
  end
end
