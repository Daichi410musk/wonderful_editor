# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Articles', type: :request do
  # ================================
  # GET /articles
  # ================================
  describe 'GET /articles' do
    subject(:request) { get(api_v1_articles_path) }

    let!(:newest_article) { create(:article) }
    let!(:middle_article) { create(:article, updated_at: 1.day.ago) }
    let!(:oldest_article) { create(:article, updated_at: 3.days.ago) }

    it '200 OK が返る' do
      request
      expect(response).to have_http_status(:ok)
    end

    it 'updated_at の降順で記事が返る' do
      request
      ids = response.parsed_body.pluck('id')
      expect(ids).to eq([newest_article.id, middle_article.id, oldest_article.id])
    end

    it 'レスポンスに body が含まれない' do
      request
      keys = response.parsed_body.first.keys
      expect(keys).not_to include('body')
    end
  end

  # ================================
  # GET /articles/:id
  # ================================
  describe 'GET /articles/:id' do
    subject(:request) { get(api_v1_article_path(article_id)) }

    context 'when the article exists' do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it '正しいステータスが返る' do
        request
        expect(response).to have_http_status(:ok)
      end

      it 'id が取得できる' do
        request
        res = response.parsed_body
        expect(res['id']).to eq(article.id)
      end

      it 'title が取得できる' do
        request
        res = response.parsed_body
        expect(res['title']).to eq(article.title)
      end

      it 'body が取得できる' do
        request
        res = response.parsed_body
        expect(res['body']).to eq(article.body)
      end

      it 'updated_at が取得できる' do
        request
        res = response.parsed_body
        expect(res['updated_at']).to be_present
      end
    end

    context 'when the article does not exist' do
      let(:article_id) { 99_999 }

      it 'RecordNotFound が発生する' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # ================================
  # POST /articles
  # ================================
  describe 'POST /articles' do
    subject(:request) { post(api_v1_articles_path, params: params) }

    let(:user) { create(:user) }
    let(:params) do
      {
        article: {
          title: 'タイトル',
          body: '本文です'
        }
      }
    end

    # rubocop:disable RSpec/AnyInstance
    before do
      allow_any_instance_of(Api::V1::BaseApiController)
        .to receive(:current_user)
        .and_return(user)
    end
    # rubocop:enable RSpec/AnyInstance

    # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    it 'current_user に紐づいた記事が作成される' do
      expect { request }.to change(Article, :count).by(1)
      expect(response).to have_http_status(:created)

      article = Article.last
      expect(article.title).to eq('タイトル')
      expect(article.body).to eq('本文です')
      expect(article.user_id).to eq(user.id)
    end
    # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
  end
end
