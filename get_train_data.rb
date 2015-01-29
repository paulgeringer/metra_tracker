require 'json'
require 'net/http'
require 'time'

module MetraTracker

  class MetraWebsiteError < StandardError; end

  def format_uri(train, from, to)
    URI.parse("http://metrarail.com/content/metra/en/home/jcr:content/trainTracker.get_train_data.json?line=#{train}&origin=#{from}&destination=#{to}")
  end

  def get_data( uri )
    begin
      Net::HTTP.get(uri)
    rescue Exception => e
      raise MetraWebsiteError, "Hmmmm, #{e.inspect}"
    end
  end

  def parse_data(data)
    JSON.parse(data)
  end
end


module MetraTracker

  class ScheduleCleaner
    attr_accessor :schedule_hash

    UNIMPORTANT_KEYS = ["trip_id", "status", "scheduled_dpt_time_note",
                        "selected", "scheduled_arv_time_note", "hasData",
                        "shouldHaveData", "isRed", "bikesText"]

    # These two are not used currently

    IMPORTANT_KEYS = ["train_num", "scheduled_dpt_time", "estimated_dpt_time",
                      "scheduled_arv_time", "estimated_arv_time",
                      "schDepartInTheAM", "schArriveInTheAM", "estDepartInTheAM",
                      "estArriveInTheAM", "notDeparted", "hasDelay"]


    TIME_KEYS = ["scheduled_dpt_time", "estimated_dpt_time",
                 "scheduled_arv_time", "estimated_arv_time",
                 "schDepartInTheAM", "schArriveInTheAM", "estDepartInTheAM",
                 "estArriveInTheAM"]

    def initialize(schedule_hash)
      @schedule_hash = clean_data(schedule_hash)
    end

    def clean_data(schedules)
      schedules.reject! { |k,v| k == "departureStopName" || k == "arrivalStopName" }
      schedules.each do |train, schedule|
        UNIMPORTANT_KEYS.each do |key|
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
      Time.parse(time_string)
    end
  end
end
