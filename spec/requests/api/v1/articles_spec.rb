# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Articles', type: :request do
  describe 'GET /articles' do
    subject(:request) { get(api_v1_articles_path) }

    let!(:newest_article) { create(:article) } # 一番新しい
    let!(:middle_article) { create(:article, updated_at: 1.day.ago) }
    let!(:oldest_article) { create(:article, updated_at: 3.days.ago) }

    it '200 OK が返る' do
      request
      expect(response).to have_http_status(:ok)
    end

    it 'updated_at の降順で記事が返る' do
      request
      expect(response.parsed_body.pluck('id')).to eq [newest_article.id, middle_article.id, oldest_article.id]
    end

    it 'レスポンスに body が含まれない' do
      request
      res = response.parsed_body

      expect(res.first.key?('body')).to be false
    end
  end
end
