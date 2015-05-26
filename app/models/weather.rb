class Weather < ActiveRecord::Base
  belongs_to :location

  def self.predict weathers, period
    return Prediction.predict(weathers, period)
  end

  def self.getWeather location, date
    return Weather.where(date: (Time.parse(date) + (60*60*10)..
                          (Time.parse(date) + 1.day)+(60*60*10)),
                          location_id: Location.find_by(name: location))
  end

  def self.getLocationId_for_prediction post_code
    postcodes = []
    Location.all.each {|l| postcodes.push(l[:postcode])}
    post_code = post_code.to_i
    if postcodes.include?(postcodes)
          return Location.find_by(postcode: post_code).id
    else
          min_diff = (postcodes[0] - post_code).abs
          postcodes.each do |p|
                  if (p - post_code).abs < min_diff
                          min_diff = (p - post_code).abs
                  end
          end
          post_code_close = post_code + min_diff
          if postcodes.include?(post_code_close)
                   return Location.find_by(postcode: post_code_close).id
          else
                    post_code_close = post_code - min_diff
                    return Location.find_by(postcode: post_code_close).id
          end
    end
  end

  def self.getWeather_for_prediction location_id
    t = Time.new
    weathers = Weather.where(date: (t-(60*60*3)..t),
                          location_id: location_id)
    if weathers.length < 1 || weathers.length ==1
                  puts "Error: not enough weathers for prediction, replace with all weather data"
                 return Weather.where(location_id: location_id)
    else
                  puts "Success: enough weathers for prediction, from 3hrs before to now"
                 return weathers
    end
  end

  def self.Lat_Long_to_Postcode lat, long
    require'nokogiri'
    require 'open-uri'
    require 'json'
          url = 'http://maps.googleapis.com/maps/api/geocode/json?latlng='+lat+','+long+'&sensor=true'
          h = JSON.parse(open(url).read)
          h_post_code = h['results'][0]['address_components'][-1]
          if h_post_code['types'].include?("postal_code")
            return h_post_code['long_name']
          else
            puts "Error cannot find post_code of the coordinates"
          end    
  end

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
        condition = forecast['weather'][0]['main']
        time = Time.at(forecast['dt'].to_i).strftime('%d %b %Y %H:%M:%S')
        
        weather = Weather.new
        weather.temperature = temp
        weather.rainfall = rainfall
        weather.wind_speed = wind_speed
        weather.wind_direction = wind_deg
        weather.date = time
        weather.condition = condition
        weather.location = location
        weather.save

        location.last_update = time
        location.save
      end
    end
  end
end
