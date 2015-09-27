module API
  module V1
    class Games < Grape::API
      prefix 'api'
      version 'v1'
      format :json

      resource :games do
        desc 'Return list of games'
        get do
          Game.all
        end
      end
    end
  end
end
