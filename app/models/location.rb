class Location < ActiveRecord::Base

  has_many :weathers

  def self.getLocation
    require 'nokogiri'
    require 'open-uri'
    require 'json'
    url = 'http://www.postcodes-australia.com/state-postcodes/vic'

    # Open the HTML link with Nokogiri
    Test.new.save
    
    begin 
      tries ||= 3
      #temp_data = JSON.parse(open("http://v0.postcodeapi.com.au/suburbs/#{postcode_array[i]}.json").read)
      @doc = Nokogiri::HTML(open(url))
    rescue OpenURI::HTTPError, SocketError, Errno::ENETUNREACH => e
      if (tries -= 1) > 0
        puts "========== http error No.#{3-tries} retry ========="
        sleep(2)
        retry
      else
        puts '========== failed to get data ========='
        exit()
      end
    else
      data_temp = @doc.css('.pclist').to_s
    end
    

    #url_expr = /<a href="(.*)">[\w\s\(\)-]*</
    postcode_expr = /title="Postcode (3\d\d\d), Victoria">3\d\d\d<\/a>\s\s<ul>\s\s<li>[\w\s]*</
    location_expr = /title="Postcode 3\d\d\d, Victoria">3\d\d\d<\/a>\s\s<ul>\s\s<li>([\w\s]*)</
    postcode_array = data_temp.scan(postcode_expr).flatten
    location_array = data_temp.scan(location_expr).flatten
    #puts postcode_array
    #puts "#{postcode_array.length} #{location_array.length}"

    #puts "#{postcode_array[515]}"
    (0..postcode_array.length).each do |i|

      # data acquiring frequency
      if(i%10 == 0)
        # if this location doesn't exit and the number of locations is less than 300
        if(Location.find_by(name: location_array[i]) == nil && Location.count() < 250)
          begin 
            tries ||= 3
            #temp_data = JSON.parse(open("http://v0.postcodeapi.com.au/suburbs/#{postcode_array[i]}.json").read)
            temp_data = JSON.parse(open("http://api.geonames.org/postalCodeSearchJSON?" +
                                        "postalcode=#{postcode_array[i]}&country=AU&" +
                                        "maxRows=1&username=maxzhx").read)
          rescue OpenURI::HTTPError, SocketError, Errno::ENETUNREACH => e
            if (tries -= 1) > 0
              puts "========== http error No.#{3-tries} retry ========="
              sleep(2)
              retry
            else
              puts '========== failed to get data ========='
            end
          else
            if(temp_data['postalCodes'].length > 0)
                location = Location.new
                #lat = temp_data[0]['latitude']
                #lon = temp_data[0]['longitude']
                lat = temp_data['postalCodes'][0]['lat']
                lon = temp_data['postalCodes'][0]['lng']
                location.name = location_array[i]
                location.lat = lat
                location.lon = lon
                location.postcode = postcode_array[i]
                location.save
                #puts "#{i} #{location_array[i]} #{postcode_array[i]} #{lat} #{lon}"
            end
          end
        end
      end
    end
  end

end
