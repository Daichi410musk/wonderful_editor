# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < DeviseTokenAuth::SessionsController
        # SPA から叩くので CSRF は完全にスキップ
        skip_before_action :verify_authenticity_token
      end
    end
  end
end
