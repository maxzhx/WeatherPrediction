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
    puts params[:location_id]
    puts params[:date]
    render :template => 'weather/data'
  end

  def postcode_data
    puts params[:post_code]
    puts params[:date]
    render :template => 'weather/data'
  end

  def postcode_prediction
    puts params[:post_code]
    puts params[:period]
    render :template => 'weather/prediction'
  end

  def lat_long_prediction
    puts params[:lat]
    puts params[:long]
    puts params[:period]
    render :template => 'weather/prediction'
  end

end
