# frozen_string_literal: true

module Api
  module V1
    class BaseApiController < ApplicationController
      # API は CSRF チェックしない
      skip_before_action :verify_authenticity_token

      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!

      private

      def current_user
        current_api_v1_user
      end

      def authenticate_user!
        authenticate_api_v1_user!
      end

      def user_signed_in?
        api_v1_user_signed_in?
      end
    end
  end
end
