# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Articles', type: :request do
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
end
