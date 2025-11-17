# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Current::Articles', type: :request do
  describe 'GET /api/v1/current/articles' do
    subject(:request_call) { get '/api/v1/current/articles', headers: headers }

    let(:user) { create(:user) }
    let(:headers) { user.create_new_auth_token }

    let!(:my_published_old) do
      create(:article, :published, user: user, updated_at: 2.days.ago)
    end

    let!(:my_published_new) do
      create(:article, :published, user: user, updated_at: 1.day.ago)
    end

    # ← ここは「存在してほしいだけ」の記事なので before で作る
    before do
      create(:article, :draft, user: user)  # 自分の下書き
      create(:article, :published)          # 他人の公開記事
    end

    # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    it '自分の公開記事のみ、updated_at の降順で返る' do
      request_call

      expect(response).to have_http_status(:ok)

      json = response.parsed_body

      # 件数: 自分の公開記事だけ
      expect(json.size).to eq 2

      # 順番: updated_at の降順
      ids = json.pluck('id')
      expect(ids).to eq [my_published_new.id, my_published_old.id]

      # body は含まれない
      first_article = json.first
      expect(first_article).to include('id', 'title', 'updated_at')
      expect(first_article).not_to have_key('body')
    end
    # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
  end
end
