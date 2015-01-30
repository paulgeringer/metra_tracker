require 'time'

module MetraTracker

  class ScheduleCleaner
    attr_accessor :schedule_hash

    def initialize(schedule_hash)
      @schedule_hash = clean_data(schedule_hash)
    end

    def clean_data(schedules)
      schedules.reject! { |k,v| k == "departureStopName" || k == "arrivalStopName" }
      schedules.each do |train, schedule|
        MetraTracker::UNIMPORTANT_KEYS.each do |key|
          schedule.reject! { |k,v| k == key }
        end
        inject_times(schedule) # for later time comparisons
      end
    end

    def inject_times(schedule)
      ["estimated", "scheduled"].each do |adjective|
        ["arv", "dpt"].each do |acronym|
          time_key = "#{adjective}_#{acronym}_time"
          meridiem = schedule["#{meridiem_key( acronym, adjective )}"]
          if schedule[time_key] # because sometimes metra doesn't send all the data
            schedule[time_key] = time_parser(schedule[time_key] + meridiem)
          end
        end
      end
      schedule["timestamp"] = time_parser(schedule["timestamp"])
      schedule
    end

    def meridiem_key(acronym, adjective)
      adj = adjective[0..2]
      if acronym == "dpt"
        "#{adj}DepartInTheAM"
      elsif acronym == "arv"
        "#{adj}ArriveInTheAM"
      end
    end

    def time_parser(time_string)
      parsed_time = Time.parse(time_string)
      current_time = Time.now
      if add_a_day?(current_time, parsed_time)
        parsed_time + one_day_in_seconds
      else
        parsed_time
      end
      # I don't care about time enough to use a gem to handle this
      # So no DST crap
    end

    def add_a_day?(current, future)
      get_meridiem(current) == 'PM' && get_meridiem(future) == 'AM'
    end

    def get_meridiem(time)
      time.strftime('%p')
    end

    def one_day_in_seconds
      60*60*24
    end

  end
end
