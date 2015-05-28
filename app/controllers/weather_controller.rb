=begin

               ┏┓   ┏┓
              ┏┛┻━━━┛┻┓
              ┃       ┃
              ┃   ━   ┃
              ┃┳┛   ┗┳┃
              ┃       ┃
              ┃   ┻   ┃
              ┃       ┃
              ┗━┓   ┏━┛
                ┃   ┃
                ┃   ┃
                ┃   ┗━━━┓
                ┃       ┣┓
                ┃       ┏┛
                ┗┓┓┏━┳┓┏┛
                 ┃┫┫ ┃┫┫
                 ┗┻┛ ┗┻┛

 Code is far away from bug with the animal protecting
=end

class WeatherController < ApplicationController

  def locations
    @locations = Location.all

    location_hash = Hash.new
    location_hash['date'] = Time.now.strftime('%d-%m-%Y')
    location_hash['locations'] = Array.new
    @locations.each do |location|
        location_hash['locations'] << JSON.parse("{\"id\": \"#{location.name}\"," \
                                                 + "\"lat\": \"#{location.lat}\"," \
                                                 + "\"lon\": \"#{location.lon}\"," \
                                                 + "\"last_update\": \"#{location.last_update.strftime('%I:%M%P %d-%m-%Y')}\"}")
    end

    respond_to do |format|
      format.json{ render :json => location_hash }  
      format.html {}
    end
  end

  def location_data
    @weathers =  Weather.getWeather(params[:location_id], params[:date])

    weather_hash = Hash.new
    weather_hash['date'] = Time.now.strftime('%d-%m-%Y')
    weather_hash['current_temp'] = @weather.last.temperature
    weather_hash['current_cond'] = @weather.last.condition
    weather_hash['measurements'] = Array.new
    @weathers.each do |weather|
        weather_hash['measurements'] << JSON.parse("{\"time\": \"#{weather.date.strftime('%I:%M:%S %P')}\"," \
                                                 + "\"lat\": \"#{location.lat}\"," \
                                                 + "\"lon\": \"#{location.lon}\"," \
                                                 + "\"last_update\": \"#{location.last_update.strftime('%I:%M%P %d-%m-%Y')}\"}")
    end
    respond_to do |format|  
      format.json{ render :json => @weathers.to_json }  
      format.html {}
    end
  end

  def postcode_data
    @locations = Location.where(postcode: params[:post_code])
    @location_weathers = Array.new
    @locations.each do |location|
      @location_weathers << Weather.getWeather(location.name, params[:date])
    end
    respond_to do |format|  
      format.json{ render :json => @location_weathers.to_json }  
      format.html {}
    end
  end

  def postcode_prediction
    puts params[:post_code]
    puts params[:period]
    #location_id = Location.find_by(postcode: params[:post_code]).id
    location_id = Weather.getLocationId_for_prediction(params[:post_code])
    weathers = Weather.getWeather_for_prediction(location_id)
    @predictions = Weather.predict(weathers, params[:period])

    respond_to do |format|  
      format.json{ render :json => @predictions.to_json }  
      format.html {render :template => 'weather/prediction'}
    end
    
  end

  def lat_long_prediction
    puts params[:lat]
    puts params[:long]
    puts params[:period]
    p postcode = Weather.Lat_Long_to_Postcode(params[:lat], params[:long])
    location_id = Weather.getLocationId_for_prediction(postcode)
    weathers = Weather.getWeather_for_prediction(location_id)
    @predictions = Weather.predict(weathers, params[:period])

    respond_to do |format|  
      format.json{ render :json => @predictions.to_json }  
      format.html {render :template => 'weather/prediction'}
    end

  end

end
