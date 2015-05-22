class WeatherController < ApplicationController

  def locations
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
