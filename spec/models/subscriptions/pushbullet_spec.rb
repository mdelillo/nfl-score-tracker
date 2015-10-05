require 'rails_helper'

describe Subscriptions::Pushbullet do
  describe 'validations' do
    it 'ensures access_token is present' do
      pushbullet_subscription = Subscriptions::Pushbullet.new(args: {})

      expect(pushbullet_subscription).to be_invalid
      expect(pushbullet_subscription.errors.messages[:args]).to include('Missing argument: access_token')
    end

    it 'ensures receiver is present' do
      pushbullet_subscription = Subscriptions::Pushbullet.new(args: {})

      expect(pushbullet_subscription).to be_invalid
      expect(pushbullet_subscription.errors.messages[:args]).to include('Missing argument: receiver')
    end

    it 'ensures identifier is present' do
      pushbullet_subscription = Subscriptions::Pushbullet.new(args: {})

      expect(pushbullet_subscription).to be_invalid
      expect(pushbullet_subscription.errors.messages[:args]).to include('Missing argument: identifier')
    end
  end

  describe '#new_score_event' do
    it 'posts the score event to pushbullet' do
      washbullet_client = instance_double('Washbullet::Client', push_note: nil)
      allow(Washbullet::Client).to receive(:new).with('hunter2').and_return(washbullet_client)

      score_event = FactoryGirl.create(:score_event,
                                       team_name: 'NYG',
                                       type: 'TD',
                                       description: 'Giants Touchdown!'
                                      )

      pushbullet_subscription = Subscriptions::Pushbullet.new(args: {
                                                                'access_token' => 'hunter2',
                                                                'receiver' => 'device',
                                                                'identifier' => 'galaxy-s6'
                                                              })
      pushbullet_subscription.new_score_event(score_event.id)

      expect(washbullet_client).to have_received(:push_note).with(receiver: :device,
                                                                  identifier: 'galaxy-s6',
                                                                  params: {
                                                                    title: 'NYG TD',
                                                                    body: 'Giants Touchdown!'
                                                                  })
    end
  end
end
