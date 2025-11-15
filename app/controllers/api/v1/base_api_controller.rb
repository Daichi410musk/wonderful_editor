# frozen_string_literal: true

module Api
  module V1
    class BaseApiController < ApplicationController
      # 認証フィルター（中身は後ろでダミー定義）
      before_action :authenticate_user!

      private

      # 課題用のダミー current_user
      # users テーブルの一番最初のユーザーを「ログインユーザー」とみなす
      def current_user
        User.first
      end

      # 課題用のダミー認証
      # 何もしないでそのまま通す
      def authenticate_user!
        # no-op
      end
    end
  end
end
