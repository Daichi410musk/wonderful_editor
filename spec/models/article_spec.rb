# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) do
    User.create!(
      name: 'だいち',
      email: 'article_user@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  let(:valid_article) { described_class.new(title: 'タイトル', body: '本文', user: user) }
  let(:invalid_article) { described_class.new(title: nil, body: '本文', user: user) }

  describe 'validations' do
    it 'is valid with title and body' do
      expect(valid_article).to be_valid
    end

    it 'is invalid without title' do
      expect(invalid_article).to be_invalid
    end
  end

  describe 'status' do
    it '下書き記事として保存できる' do
      article = described_class.new(title: 'draft title', body: '内容', status: :draft, user: user)
      expect(article).to be_valid
    end

    it '公開記事として保存できる' do
      article = described_class.new(title: 'pub title', body: '内容', status: :published, user: user)
      expect(article).to be_valid
    end
  end
end
