module API
  module V1
    class Root < Grape::API
      prefix 'api'
      version 'v1'
      format :json

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!(e.message, 404)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        error!(e.message, 422)
      end

      mount API::V1::Games
      mount API::V1::Subscriptions
    end
  end
end
