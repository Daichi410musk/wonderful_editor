# frozen_string_literal: true

module Api
  module V1
    module Articles
      class DraftsController < BaseApiController
        # 開発用：とりあえず認証をスキップ
        skip_before_action :authenticate_user!, only: %i[index show]

        # GET /api/v1/articles/drafts
        def index
          user = User.first

          drafts = user.articles
                       .draft
                       .order(updated_at: :desc)

          render json: drafts,
                 each_serializer: Api::V1::ArticlePreviewSerializer
        end

        # GET /api/v1/articles/drafts/:id
        def show
          user = User.first

          draft = user.articles
                      .draft
                      .find(params[:id])

          render json: draft,
                 serializer: Api::V1::ArticleSerializer
        end
      end
    end
  end
end
