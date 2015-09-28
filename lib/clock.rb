require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  every(10.seconds, 'update_games') { NflScoreTracker::GameUpdateService.update_games }
end
