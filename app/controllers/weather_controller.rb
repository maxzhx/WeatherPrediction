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
  # api
  #
  # lat and long to postcode
  # http://maps.googleapis.com/maps/api/geocode/json?latlng=-37,144&sensor=true
  #
  # postcode to lat and long
  # http://v0.postcodeapi.com.au/suburbs/3463.json

  def locations
    @locations = Location.all
  end

  def location_data
    @weathers =  Weather.getWeather(params[:location_id], params[:date])
    puts params[:location_id]
    puts params[:date]
  end

  def postcode_data
    @locations = Location.where(postcode: params[:post_code])
    @location_weathers = Array.new
    @locations.each do |location|
      @location_weathers << Weather.getWeather(location.name, params[:date])
    end
    puts '============='
    puts @locations.length
    puts params[:post_code]
    puts params[:date]
  end

  def postcode_prediction
    puts params[:post_code]
    puts params[:period]
    #location_id = Location.find_by(postcode: params[:post_code]).id
    location_id = Weather.getLocationId_for_prediction(params[:post_code])
    weathers = Weather.getWeather_for_prediction(location_id)
    @predictions = Weather.predict(weathers, params[:period])
    render :template => 'weather/prediction'
  end

  def lat_long_prediction
    puts params[:lat]
    puts params[:long]
    puts params[:period]
    p postcode = Weather.Lat_Long_to_Postcode(params[:lat], params[:long])
    location_id = Weather.getLocationId_for_prediction(postcode)
    weathers = Weather.getWeather_for_prediction(location_id)
    @predictions = Weather.predict(weathers, params[:period])
    render :template => 'weather/prediction'
  end

end
