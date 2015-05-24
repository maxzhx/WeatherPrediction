class Weather < ActiveRecord::Base
	belongs_to :location

    def self.getForecast
      require'nokogiri'
      require 'open-uri'
      require 'json'

      locations = Location.all
      locations.each_with_index do |location,index|
        base_url = 'http://api.openweathermap.org/data/2.5/weather?'
        lat = location.lat
        lon = location.lon
        api_key = 'dd2f2e3703103d3f94ac20de6a2e9c50'
        
        # try 3 times to get data
        begin
          tries ||= 3
          forecast = JSON.parse(open(base_url + 'lat=' + lat.to_s + '&lon=' + lon.to_s + 
                                     '&units=metric&APPID=' + api_key).read)
        rescue OpenURI::HTTPError, SocketError, Errno::ENETUNREACH => e
          if (tries -= 1) > 0
            puts "========== http error No.#{3-tries} retry ========="
            sleep(2)
            retry
          else
            puts '========== failed to get data ========='
          end
        else
          if(forecast['rain']!=nil)
            rainfall = forecast['rain']['3h'].to_f
          else
            rainfall = 0.0
          end
          temp = forecast['main']['temp'].to_f
          wind_speed = forecast['wind']['speed'].to_f
          wind_deg = forecast['wind']['deg'].to_f
          time = Time.at(forecast['dt'].to_i).strftime('%d %b %Y %H:%M:%S')
          
          weather = Weather.new
          weather.temperature = temp
          weather.rainfall = rainfall
          weather.wind_speed = wind_speed
          weather.wind_direction = wind_deg
          weather.date = time
          weather.location = location
          weather.save

          location.last_update = time
          location.save
        end
      end
    end
end