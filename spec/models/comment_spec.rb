# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) do
    User.create!(
      name: 'だいち',
      email: 'comment_user@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  let(:article) do
    Article.create!(
      title: 'タイトル',
      body: '本文',
      user: user
    )
  end

  let(:valid_comment) { described_class.new(body: 'コメント内容', user: user, article: article) }
  let(:invalid_comment) { described_class.new(body: nil, user: user, article: article) }

  describe 'validations' do
    it 'is valid with body' do
      expect(valid_comment).to be_valid
    end

    it 'is invalid without body' do
      expect(invalid_comment).to be_invalid
    end
  end
end
