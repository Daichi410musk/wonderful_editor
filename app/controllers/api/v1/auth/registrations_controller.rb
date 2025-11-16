# frozen_string_literal: true

# app/controllers/api/v1/auth/registrations_controller.rb
module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        skip_before_action :verify_authenticity_token

        private

        def sign_up_params
          params.permit(:name, :email, :password, :password_confirmation)
        end
      end
    end
  end
end
