# frozen_string_literal: true

# spec/requests/api/v1/auth/registrations_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Registrations', type: :request do
  describe 'POST /api/v1/auth' do
    let(:valid_params) do
      {
        name: 'Daichi',
        email: 'signup_test@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    context 'when signup is successful' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'creates a new user' do
        post '/api/v1/auth', params: valid_params

        expect(response).to have_http_status(:ok)
        json = response.parsed_body

        expect(json['status']).to eq('success')
        expect(json['data']['email']).to eq(valid_params[:email])
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'when email is already taken' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'returns 422 when email is already taken' do
        User.create!(valid_params)

        post '/api/v1/auth', params: valid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json = response.parsed_body

        expect(json['errors']['email']).to include('has already been taken')
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end
end
