# frozen_string_literal: true

module Api
  module V1
    class ArticlesController < BaseApiController
      # 一覧・詳細は誰でも見れる（ただし公開記事だけ）
      skip_before_action :authenticate_user!, only: %i[index show]
      # 更新・削除は自分の記事だけ
      before_action :set_article, only: %i[update destroy]

      # GET /api/v1/articles
      def index
        # 公開記事だけ & body を含めない
        articles = Article.published
                          .order(updated_at: :desc)
                          .select(:id, :title, :updated_at)

        render json: articles
      end

      # GET /api/v1/articles/:id
      def show
        # 公開記事だけ取得できるようにする
        article = Article.published.find(params[:id])
        render json: article
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
        # 自分の記事だけ更新・削除できるようにしておく
        @article = current_user.articles.find(params[:id])
      end

      def article_params
        # status を許可（"draft" or "published" が入る想定）
        params.require(:article).permit(:title, :body, :status).tap do |p|
          # パラメータで status が来てなかったら draft にしておきたい場合はここ
          p[:status] ||= 'draft'
        end
      end
    end
  end
end
