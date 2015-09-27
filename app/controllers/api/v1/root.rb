module API
  module V1
    class Root < Grape::API
      prefix 'api'
      version 'v1'
      format :json

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!(e.message, 404)
      end

      mount API::V1::Games
    end
  end
end
