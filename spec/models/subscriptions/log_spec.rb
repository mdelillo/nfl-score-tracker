require 'rails_helper'

describe Subscriptions::Log do
  describe '#new_score_event' do
    it 'logs the score event' do
      allow(Rails.logger).to receive(:info)
      score_event = FactoryGirl.create(:score_event,
                                       team_name: 'NYG',
                                       type: 'TD',
                                       description: 'Giants Touchdown!'
                                      )

      Subscriptions::Log.new.new_score_event(score_event.id)

      expect(Rails.logger)
        .to have_received(:info)
        .with('[NYG TD] Giants Touchdown!')
    end
  end
end
