module Subscriptions
  class Log < Subscription
    def new_score_event(score_event_id)
      score_event = ScoreEvent.find(score_event_id)
      logger.info("[#{score_event.team_name} #{score_event.type}] #{score_event.description}")
    end
  end
end
