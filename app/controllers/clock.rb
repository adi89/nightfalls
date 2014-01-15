require_relative "../../config/boot"
require_relative "../../config/environment"

require "clockwork"
module Clockwork
    every(3.minutes, 'tweets job') { HighPriorityCategoriesWorker.perform_async }

    every(8.minutes, 'tweets job') { LowPriorityCategoriesWorker.perform_async }
end


