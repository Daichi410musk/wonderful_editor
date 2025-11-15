# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_user) do
    described_class.new(
      name: 'だいち',
      email: 'user@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  let(:invalid_user) do
    described_class.new(
      name: nil,
      email: 'user@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  describe 'validations' do
    it 'is valid with name, email and password' do
      expect(valid_user).to be_valid
    end

    it 'is invalid without name' do
      expect(invalid_user).to be_invalid
    end
  end
end
