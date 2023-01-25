# frozen_string_literal: true

require 'rails_helper'

describe Api::ChecksController do
  include ActiveJob::TestHelper

  describe '#create' do
    let(:repository) { repositories(:repo_one) }
    let(:params) do
      {
        'repository' => {
          'id' => repository.github_id,
          'name' => repository.name
        }
      }
    end

    it 'creates repository check' do
      expect do
        post(:create, params:)
      end.to change(Repository::Check, :count).by(1)
      expect(response).to be_successful

      perform_enqueued_jobs

      expect(Repository::Check.last.aasm_state).to eq('finished')
    end
  end
end
