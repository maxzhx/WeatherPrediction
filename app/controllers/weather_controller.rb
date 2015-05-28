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

    respond_to do |format|
      format.json{ render :json => Location.getJsonLocations(@locations) }  
      format.html {}
    end
  end

  def location_data
    @weathers =  Weather.getWeather(params[:location_id], params[:date])

    respond_to do |format|  
      format.json{ render :json => Weather.getLocationWeatherJson(@weathers) }  
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
      format.json{ render :json => Weather.getPostcodeWeatherJson(@locations,@location_weathers) }  
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

    prediction_json = {location_id: Location.find_by(id: location_id).name, predictions: {}}
    @predictions.each_index do |i|
          temp = {}
          temp.store(:time, Time.at(@predictions[i].time))
          temp.store(:rain, {value: @predictions[i].rainfall_value, probability: @predictions[i].rainfall_probability})
          temp.store(:winddir, {value: @predictions[i].winddir_value, probability: @predictions[i].winddir_probability})
          temp.store(:windspeed, {value: @predictions[i].windspeed_value, probability: @predictions[i].windspeed_probability})
          temp.store(:temp, {value: @predictions[i].temp_value, probability: @predictions[i].temp_probability})
          prediction_json[:predictions].store(i*10, temp)
    end

    respond_to do |format|  
      format.json{ render :json => prediction_json.to_json }  
      format.html {render :template => 'weather/prediction'}
    end
    
  end

  def lat_long_prediction
    puts " - lat: #{params[:lat]}"
    puts " - lon: #{params[:long]}"
    puts " - period: #{params[:period]}"
    postcode = Weather.Lat_Long_to_Postcode(params[:lat], params[:long])
    puts " - postcode: #{postcode}"
    location_id = Weather.getLocationId_for_prediction(postcode)
    weathers = Weather.getWeather_for_prediction(location_id)
    @predictions = Weather.predict(weathers, params[:period])

    prediction_json = {lattitude: params[:lat], longitude: params[:long], predictions: {}}
    @predictions.each_index do |i|
          temp = {}
          temp.store(:time, Time.at(@predictions[i].time))
          temp.store(:rain, {value: @predictions[i].rainfall_value, probability: @predictions[i].rainfall_probability})
          temp.store(:winddir, {value: @predictions[i].winddir_value, probability: @predictions[i].winddir_probability})
          temp.store(:windspeed, {value: @predictions[i].windspeed_value, probability: @predictions[i].windspeed_probability})
          temp.store(:temp, {value: @predictions[i].temp_value, probability: @predictions[i].temp_probability})
          prediction_json[:predictions].store(i*10, temp)
    end

    respond_to do |format|  
      format.json{ render :json => prediction_json.to_json }  
      format.html {render :template => 'weather/prediction'}
    end

  end

end
