module API
  module V1
    class Games < Grape::API
      resource :games do
        desc 'Return list of games'
        get do
          Game.all
        end

        desc 'Create new game'
        post do
          Game.create!(game_center_id: params[:game_center_id])
        end

        desc 'Delete a game'
        delete ':id' do
          Game.destroy(params[:id])
        end
      end
    end
  end
end
