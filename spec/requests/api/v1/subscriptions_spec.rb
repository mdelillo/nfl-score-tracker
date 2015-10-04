require 'rails_helper'

describe 'Subscriptions' do
  describe 'GET /api/v1/subscriptions' do
    it 'returns a list of all subscriptions' do
      subscriptions = FactoryGirl.create_pair(:subscription, type: 'Subscriptions::Log')

      get '/api/v1/subscriptions'

      expect(response.status).to eq 200
      expect(json_body.map { |s| s['id'] }).to eq subscriptions.map(&:id)
      expect(json_body.first['type']).to eq 'Subscriptions::Log'
    end
  end

  describe 'GET /api/v1/subscriptions/:id' do
    context 'when the subscription exists' do
      it 'returns single subscription' do
        subscription = FactoryGirl.create(:subscription, type: 'Subscriptions::Log')

        get "/api/v1/subscriptions/#{subscription.id}"

        expect(response.status).to eq 200
        expect(json_body['id']).to eq subscription.id
        expect(json_body['type']).to eq 'Subscriptions::Log'
      end
    end

    context 'when the subscription does not exist' do
      it 'responds with 404' do
        get '/api/v1/subscriptions/non-existent'

        expect(response.status).to eq 404
        expect(json_body['error']).to eq "Couldn't find Subscription with 'id'=non-existent"
      end
    end
  end

  describe 'POST /api/v1/subscriptions' do
    context 'with valid parameters' do
      it 'creates a new subscription' do
        post '/api/v1/subscriptions',
             format: :json,
             game_id: FactoryGirl.create(:game).id,
             type: 'Subscriptions::Log',
             args: { formatter: '[%timestamp] %message' }

        expect(response.status).to eq 201
        expect(json_body['type']).to eq 'Subscriptions::Log'
        expect(json_body['args']['formatter']).to eq '[%timestamp] %message'
      end
    end

    context 'with invalid parameters' do
      it 'responds with 422' do
        post '/api/v1/subscriptions', format: :json

        expect(response.status).to eq 422
        expect(json_body['error']).to include('Validation failed')
      end
    end
  end

  describe 'DELETE /api/v1/subscriptions/:id' do
    context 'when the subscription exists' do
      it 'deletes the subscription' do
        subscription = FactoryGirl.create(:subscription, type: 'Subscriptions::Log')

        delete "/api/v1/subscriptions/#{subscription.id}"

        expect(response.status).to eq 200
        expect(json_body['id']).to eq subscription.id
        expect(json_body['type']).to eq 'Subscriptions::Log'
      end
    end

    context 'when the subscription does not exist' do
      it 'responds with 404' do
        delete '/api/v1/subscriptions/non-existent'

        expect(response.status).to eq 404
        expect(json_body['error']).to eq "Couldn't find Subscription with 'id'=non-existent"
      end
    end
  end
end
