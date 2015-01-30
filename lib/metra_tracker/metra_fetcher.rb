require 'net/http'
require 'json'

module MetraTracker

  class MetraFetcher
    attr_reader :line, :depart_station, :arrive_station, :metra_endpoint

    def initialize(line, depart_station, arrive_station)
      @line = line
      @depart_station = depart_station
      @arrive_station = arrive_station
    end

    def schedule_hash
      uri = format_uri
      raw_data = get_data(uri)
      parse_data(raw_data)
    end

    private 

    def format_uri
      URI.parse("#{MetraTracker::METRA_ENDPOINT}line=#{line}&origin=#{depart_station}&destination=#{arrive_station}")
    end

    def get_data(uri)
      begin
        Net::HTTP.get(uri)
      rescue Exception => e
        raise MetraTracker::MetraWebsiteError, "Hmmmm, #{e.inspect}"
      end
    end

    def parse_data(data)
      JSON.parse(data)
    end

  end

end
