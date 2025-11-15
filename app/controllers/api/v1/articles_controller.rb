# frozen_string_literal: true

module Api
  module V1
    class ArticlesController < BaseApiController
      skip_before_action :authenticate_user!, only: %i[index show]

      def index
        articles = Article.order(updated_at: :desc)
        render json: articles.select(:id, :title, :updated_at)
      end

      def show
        article = Article.find(params[:id])
        render json: {
          id: article.id,
          title: article.title,
          body: article.body,
          updated_at: article.updated_at
        }
      end
    end
  end
end
