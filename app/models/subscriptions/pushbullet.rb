module Subscriptions
  class Pushbullet < Subscription
    def new_score_event(score_event_id)
      score_event = ScoreEvent.find(score_event_id)
      uri = URI('http://pushbullet.com/api-endpoint')
      connection = Net::HTTP.new(uri.host)
      connection.start do |http|
        request = Net::HTTP::Post.new(uri)
        request.set_form_data('subject' => "#{score_event.team_name} #{score_event.type}",
                              'body' => score_event.description)
        http.request(request)
      end
    end
  end
end
