# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Articles', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  describe 'GET /articles' do
    it '200 OK が返る' do
      get api_v1_articles_path, headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    it 'updated_at の降順で返る' do
      old_article = create(:article, user: user, updated_at: 1.day.ago)
      new_article = create(:article, user: user, updated_at: Time.current)

      get api_v1_articles_path, headers: auth_headers
      ids = response.parsed_body.pluck('id')

      expect(ids).to eq([new_article.id, old_article.id])
    end

    it 'body が含まれない' do
      create(:article, user: user)

      get api_v1_articles_path, headers: auth_headers
      keys = response.parsed_body.first.keys

      expect(keys).not_to include('body')
    end
  end

  describe 'GET /articles/:id' do
    let(:article) { create(:article, user: user) }

    # rubocop:disable RSpec/ExampleLength
    it '必要な情報が返る' do
      get api_v1_article_path(article), headers: auth_headers
      json = response.parsed_body

      expect(json.slice('id', 'title', 'body')).to eq(
        'id' => article.id,
        'title' => article.title,
        'body' => article.body
      )
    end
    # rubocop:enable RSpec/ExampleLength

    it '存在しない場合は RecordNotFound' do
      expect do
        get api_v1_article_path(999_999), headers: auth_headers
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST /articles' do
    it '作成される' do
      post api_v1_articles_path,
           params: { article: { title: 't', body: 'b' } },
           headers: auth_headers

      json = response.parsed_body
      expect(json).to include('title' => 't', 'body' => 'b')
    end
  end

  describe 'PATCH /articles/:id' do
    let(:article) { create(:article, user: user) }

    it '更新される' do
      patch api_v1_article_path(article),
            params: { article: { title: 'u', body: 'bb' } },
            headers: auth_headers

      json = response.parsed_body
      expect(json).to include('title' => 'u', 'body' => 'bb')
    end

    it 'バリデーションエラーで 422' do
      patch api_v1_article_path(article),
            params: { article: { title: '' } },
            headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /articles/:id' do
    let!(:article) { create(:article, user: user) }

    it 'current_user に紐づいた記事が削除される' do
      expect do
        delete api_v1_article_path(article), headers: auth_headers
      end.to change(Article, :count).by(-1)
    end

    it '204 No Content が返る' do
      new_article = create(:article, user: user)
      delete api_v1_article_path(new_article), headers: auth_headers

      expect(response).to have_http_status(:no_content)
    end
  end
end
