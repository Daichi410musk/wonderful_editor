# frozen_string_literal: true

module Api
  module V1
    module Current
      class ArticlesController < BaseApiController
        # ✨ 一旦 index だけ認証スキップ（開発用）
        skip_before_action :authenticate_user!, only: :index

        # GET /api/v1/current/articles
        def index
          # 本当は current_user を使うが、今は User.first で代用
          user = User.first

          articles = user.articles
                         .published
                         .order(updated_at: :desc)

          render json: articles,
                 each_serializer: Api::V1::ArticlePreviewSerializer
        end
      end
    end
  end
end
