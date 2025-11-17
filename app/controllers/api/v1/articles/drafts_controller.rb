# frozen_string_literal: true

module Api
  module V1
    module Articles
      class DraftsController < BaseApiController
        # GET /api/v1/articles/drafts
        def index
          articles = current_user.articles.draft.order(updated_at: :desc)
          render json: articles, each_serializer: ArticleSerializer
        end

        # GET /api/v1/articles/drafts/:id
        def show
          article = current_user.articles.draft.find(params[:id])
          render json: article, serializer: ArticleSerializer
        end
      end
    end
  end
end
