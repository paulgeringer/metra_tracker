module MetraTracker
  class TextGenerator
    attr_accessor :output_string, :schedule_hash

    def initialize(schedule_hash)
      @output_string = "" 
      @schedule_hash = schedule_hash
    end

    def create_string
      schedule_hash.each do |train, info_hash|
        MetraTracker::OUTPUT_HASH.each do |key, string|
          @output_string += "#{string}#{info_hash[key]}"
        end
        difference = time_difference(info_hash['scheduled_dpt_time'], info_hash['timestamp'])
        arrival_time(difference)
      end
    end

    def arrival_time(time_ahead)
      @output_string += ". It is going to arrive at your departure station in #{time_ahead} minutes.\n"
    end

    def time_difference(departure, timestamp)
      minutize(departure - timestamp)
    end

    def minutize(seconds)
      (seconds / 60).round(1)
    end

  end
end
