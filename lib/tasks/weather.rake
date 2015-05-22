namespace :weather do
  desc "TODO"
  task :getStation => :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'json'
    url = 'http://www.postcodes-australia.com/state-postcodes/vic'

    # Open the HTML link with Nokogiri
    @doc = Nokogiri::HTML(open(url))
    data_temp = @doc.css('.pclist').to_s
    #puts data_temp

    #url_expr = /<a href="(.*)">[\w\s\(\)-]*</
    postcode_expr = /title="Postcode (3\d\d\d), Victoria">3\d\d\d<\/a>\s\s<ul>\s\s<li>[\w\s]*</
    location_expr = /title="Postcode 3\d\d\d, Victoria">3\d\d\d<\/a>\s\s<ul>\s\s<li>([\w\s]*)</
    postcode_array = data_temp.scan(postcode_expr).flatten
    location_array = data_temp.scan(location_expr).flatten
    puts postcode_array
    puts "#{postcode_array.length} #{location_array.length}"

    puts "#{postcode_array[515]}"
    (0..postcode_array.length).each do |i|
      if(i%5 == 0)
        temp_data = JSON.parse(open("http://v0.postcodeapi.com.au/suburbs/#{postcode_array[i]}.json").read)
        if(temp_data.length!=0)
          lat = temp_data[0]['latitude']
          lon = temp_data[0]['longitude']
          puts "#{i} #{location_array[i]} #{postcode_array[i]} #{lat} #{lon}"
        end
      end
    end

    #<li><a href="http://www.postcodes-australia.com/postcodes/3000" title="Postcode 3000, Victoria">3000</a>
    #<ul>
    #<li>Melbourne</li>

  end

  desc "TODO"
  task :getForecast => :environment do
    require'nokogiri'
    require 'open-uri'
    require 'json'
    base_url = 'http://api.openweathermap.org/data/2.5/weather?'
    lat = -37
    lon = 144
    api_key = 'dd2f2e3703103d3f94ac20de6a2e9c50'
    forecast = JSON.parse(open(base_url + 'lat=' + lat.to_s + '&lon=' + lon.to_s + 
                               '&units=metric&APPID=' + api_key).read)
    if(forecast['rain']!=nil)
      rainfall = forecast['rain']['3h'].to_f
    else
      rainfall = 0.0
    end
    temp = forecast['main']['temp'].to_f
    wind_speed = forecast['wind']['speed'].to_f
    wind_deg = forecast['wind']['deg'].to_f
    time = Time.at(forecast['dt'].to_i).strftime('%d %b %Y %H:%M:%S')
    puts rainfall
    puts temp
    puts wind_speed
    puts wind_deg
    puts time
    #Test.new().save()
  end
end
