# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Articles::Drafts', type: :request do
  let(:user)    { create(:user) }
  let(:headers) { user.create_new_auth_token }

  describe 'GET /api/v1/articles/drafts' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    subject(:request_call) { get '/api/v1/articles/drafts', headers: headers }

    let!(:my_draft_old)  { create(:article, :draft, user: user, updated_at: 2.days.ago) }
    let!(:my_draft_new)  { create(:article, :draft, user: user, updated_at: 1.day.ago) }
    let!(:my_published)  { create(:article, :published, user: user) }
    let!(:others_draft)  { create(:article, :draft) }

    it '自分の下書きのみ updated_at 降順で返る' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      request_call

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      # 公開記事の index と同じ形式に合わせる
      articles = json.is_a?(Array) ? json : json['articles']

      expect(articles.size).to eq 2
      expect(articles.pluck('id')).to eq [my_draft_new.id, my_draft_old.id]
      # ついでに「他人の下書き」「自分の公開記事」が含まれないことも保証
      expect(articles.pluck('id')).not_to include(others_draft.id, my_published.id)
    end

    it 'body は含まれない' do
      request_call

      json = JSON.parse(response.body)
      articles = json.is_a?(Array) ? json : json['articles']

      expect(articles.first).not_to be_key('body')
    end
  end

  describe 'GET /api/v1/articles/drafts/:id' do
    subject(:request_call) { get "/api/v1/articles/drafts/#{article_id}", headers: headers }

    let!(:my_draft) { create(:article, :draft, user: user) }

    context 'when the article belongs to the current user' do
      let(:article_id) { my_draft.id }

      it '詳細が取得できる' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
        request_call

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json['id']).to eq my_draft.id
        expect(json['title']).to eq my_draft.title
        expect(json['body']).to eq my_draft.body
      end
    end

    context 'when the article belongs to another user' do
      let(:others_draft) { create(:article, :draft) }
      let(:article_id)   { others_draft.id }

      it 'RecordNotFound となる' do
        expect { request_call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
