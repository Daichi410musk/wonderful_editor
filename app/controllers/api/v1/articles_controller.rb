# frozen_string_literal: true

module Api
  module V1
    class ArticlesController < BaseApiController
      # BaseApiController に認証の before_action を書いているなら、
      # 一覧は誰でも見れるように index だけスキップする
      # 例）before_action :authenticate_api_v1_user! があるなら↓を有効化
      # skip_before_action :authenticate_api_v1_user!, only: :index

      def index
        articles = Article.order(updated_at: :desc)

        render json: articles,
               each_serializer: Api::V1::ArticlePreviewSerializer
      end
    end
  end
end
