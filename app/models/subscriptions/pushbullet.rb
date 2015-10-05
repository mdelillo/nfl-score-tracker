module Subscriptions
  class Pushbullet < Subscription
    REQUIRED_ARGS = %w(
      access_token
      receiver
      identifier
    )
    validate :required_args

    def required_args
      REQUIRED_ARGS.each do |arg|
        errors.add(:args, "Missing argument: #{arg}") if args[arg].blank?
      end
    end

    def new_score_event(score_event_id)
      score_event = ScoreEvent.find(score_event_id)
      washbullet_client = Washbullet::Client.new(args['access_token'])
      washbullet_client.push_note(
        receiver: args['receiver'].to_sym,
        identifier: args['identifier'],
        params: {
          title: "#{score_event.team_name} #{score_event.type}",
          body:  score_event.description
        }
      )
    end
  end
end
