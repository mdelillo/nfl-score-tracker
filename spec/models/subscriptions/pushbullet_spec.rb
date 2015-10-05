require 'rails_helper'

describe Subscriptions::Pushbullet do
  describe '#new_score_event' do
    it 'posts the score event to pushbullet' do
      stubbed_request = stub_request(:post, 'http://pushbullet.com/api-endpoint')
                        .with(body: { subject: 'NYG TD', body: 'Giants Touchdown!' })
                        .to_return(status: 200)
      score_event = FactoryGirl.create(:score_event,
                                       team_name: 'NYG',
                                       type: 'TD',
                                       description: 'Giants Touchdown!'
                                      )

      Subscriptions::Pushbullet.new.new_score_event(score_event.id)

      expect(stubbed_request).to have_been_requested
    end
  end
end
