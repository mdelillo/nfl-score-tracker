module API
  module V1
    class Games < Grape::API
      resource :games do
        desc 'Return all games'
        get do
          present Game.all
        end

        desc 'Return a game'
        get ':id' do
          present Game.find(params[:id])
        end

        desc 'Create a new game'
        post do
          present Game.create!(game_center_id: params[:game_center_id])
        end

        desc 'Delete a game'
        delete ':id' do
          present Game.destroy(params[:id])
        end
      end
    end
  end
end
