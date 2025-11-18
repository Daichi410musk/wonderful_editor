# frozen_string_literal: true

module Api
  module V1
    class ArticleSerializer < ActiveModel::Serializer
      attributes :id, :title, :body, :updated_at
      belongs_to :user
    end
  end
end
