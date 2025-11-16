# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Sessions', type: :request do
  describe 'POST /api/v1/auth/sign_in' do
    subject(:login_request) { post '/api/v1/auth/sign_in', params: params }

    let(:user) { create(:user, password: 'password', password_confirmation: 'password') }
    let(:params) { { email: user.email, password: password } }

    context 'when params are valid' do
      let(:password) { 'password' }

      it 'returns 200 OK' do
        login_request
        expect(response).to have_http_status(:ok)
      end

      it 'returns access-token header' do
        login_request
        expect(response.headers['access-token']).to be_present
      end

      it 'returns client header' do
        login_request
        expect(response.headers['client']).to be_present
      end

      it 'returns uid header' do
        login_request
        expect(response.headers['uid']).to eq(user.email)
      end

      it 'returns user data in body' do
        login_request
        body = response.parsed_body
        expect(body['data']['email']).to eq(user.email)
      end
    end

    context 'when params are invalid' do
      let(:password) { 'wrong_password' }

      it 'returns 401 unauthorized' do
        login_request
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns errors in body' do
        login_request
        body = response.parsed_body
        expect(body['errors']).to be_present
      end
    end
  end
end
