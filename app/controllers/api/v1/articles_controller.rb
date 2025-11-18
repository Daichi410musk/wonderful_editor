# frozen_string_literal: true

module Api
  module V1
    class ArticlesController < BaseApiController
      skip_before_action :authenticate_user!, only: %i[index show create update destroy]
      before_action :set_article, only: %i[update destroy]

      def index
        articles = Article.published.order(updated_at: :desc)

        render json: articles,
               each_serializer: Api::V1::ArticlePreviewSerializer
      end

      def show
        article = Article.published.find(params[:id])

        render json: article,
               serializer: Api::V1::ArticleSerializer
      end

      def create
        user = User.first
        article = user.articles.new(article_params)

        if article.save
          render json: article,
                 serializer: Api::V1::ArticleSerializer,
                 status: :created
        else
          render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @article.update(article_params)
          render json: @article,
                 serializer: Api::V1::ArticleSerializer
        else
          render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @article.destroy!
        head :no_content
      end

      private

      def set_article
        @article = Article.find(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :body, :status).tap do |p|
          p[:status] ||= 'draft'
        end
      end
    end
  end
end
