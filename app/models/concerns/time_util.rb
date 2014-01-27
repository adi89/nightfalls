module TimeUtil
  extend ActiveSupport::Concern

  module ClassMethods
    def days_ago(days)
      Time.at(days_calculation(days))
    end

    def days_calculation(days)
      Time.now.to_i - (days * 3600 * 24)
    end

    def created_at_offset_factor
      3600 * 5 #5 hour pg offset's created
    end

    def minutes_calculation(minutes)
      Time.now.to_i + created_at_offset_factor - (60 * minutes) #5 hour offset
    end

  end






end
