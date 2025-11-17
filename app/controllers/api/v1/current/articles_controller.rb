# frozen_string_literal: true

module Api
  module V1
    module Current
      class ArticlesController < BaseApiController
        # GET /api/v1/current/articles
        def index
          # 自分が書いた公開記事のみ & body を含めない
          articles = current_user.articles
                                 .published
                                 .order(updated_at: :desc)
                                 .select(:id, :title, :updated_at)

          render json: articles
        end
      end
    end
  end
end
