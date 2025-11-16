# frozen_string_literal: true

module Api
  module V1
    class ArticlesController < BaseApiController
      skip_before_action :authenticate_user!, only: %i[index show]
      before_action :set_article, only: %i[show update destroy]

      # GET /api/v1/articles
      def index
        articles = Article.order(updated_at: :desc).select(:id, :title, :updated_at)
        render json: articles
      end

      # GET /api/v1/articles/:id
      def show
        render json: @article
      end

      # POST /api/v1/articles
      def create
        article = current_user.articles.new(article_params)

        if article.save
          render json: article, status: :created
        else
          render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/articles/:id
      def update
        if @article.update(article_params)
          render json: @article
        else
          render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/articles/:id
      def destroy
        @article.destroy!
        head :no_content
      end

      private

      def set_article
        # 自分の記事だけ更新・参照できるようにしておく
        @article = current_user.articles.find(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :body)
      end
    end
  end
end
