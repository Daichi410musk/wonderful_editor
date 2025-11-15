# frozen_string_literal: true

module Api
  module V1
    class ArticlePreviewSerializer < ActiveModel::Serializer
      attributes :id, :title, :updated_at
    end
  end
end
