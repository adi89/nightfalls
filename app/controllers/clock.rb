require_relative "../../config/boot"
require_relative "../../config/environment"
require "clockwork"
module Clockwork
  every(5.minutes, 'tweets job') { InformationWorker.perform_async }
  every(10.minutes, 'tweets job') { PowerPlayerWorker.perform_async }
  every(16.minutes, 'tweets job') { PromoterWorker.perform_async }
  every(5.minutes, 'tweets job') { ScenesterWorker.perform_async }
  every(16.minutes, 'tweets job') { DjsWorker.perform_async }

end
#


