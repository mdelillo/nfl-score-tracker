module API
  module V1
    class Subscriptions < Grape::API
      resource :subscriptions do
        desc 'Return all subscriptions'
        get do
          present Subscription.all
        end

        desc 'Return a subscription'
        get ':id' do
          present Subscription.find(params[:id])
        end

        desc 'Create a new subscription'
        post do
          present Subscription.create!(
            game_id: params[:game_id],
            type: params[:type],
            args: params[:args]
          )
        end

        desc 'Delete a subscription'
        delete ':id' do
          present Subscription.destroy(params[:id])
        end
      end
    end
  end
end
