class Prediction
	attr_accessor :time
	attr_accessor :rainfall_value
	attr_accessor :rainfall_probability
	attr_accessor :winddir_value
	attr_accessor :winddir_probability
	attr_accessor :windspeed_value
	attr_accessor :windspeed_probability
	attr_accessor :temp_value
	attr_accessor :temp_probability
	
	def self.testprint
		p "@@@@@@@@~~~~ test print"
	end

	def self.timeAbstract weathers	
		arr = []
		weathers.each {|v| arr.push(v[:date].to_i.to_f)}
		return arr
	end

	def self.dataAbstract weathers, key	
		arr = []
		weathers.each {|v| arr.push(v[key])}
		return arr
	end

	def self.getValue reg, time
		if reg[:reg_type] == 'linear'
			#puts "getting linear value ..."	
			return reg[:coeff]*time+reg[:constant]
		elsif reg[:reg_type] == 'polynomial'
			#puts "getting polynomial value ..."
			value = 0
			coeffs = reg[:coeff]
			coeffs.each_index do |i|
				value +=coeffs[i]*(time**(coeffs.length-i))
			end
			return value+reg[:constant]
		elsif reg[:reg_type] == 'exponential'
			#puts "getting exponential value ..."
			return reg[:coeff]*Math.exp(time)+reg[:constant]
		elsif reg[:reg_type] == 'logarithmic'
			#puts "getting logarithmic value ..."
			return reg[:coeff]*Math.log(time)+reg[:constant]
		end
	end

	def self.getProbability reg
		return (1/(reg[:variance]+1)).round(1)
	end

	def self.predict weathers, period
		puts "~~~~~~~Predictin.predict~~~~~~"
		puts weathers
		puts period

		predictions = []
		(period.to_i/10+1).times do |v|
			time_arr = timeAbstract(weathers) 		
			rainfall_arr = dataAbstract(weathers, :rainfall) 
			wind_direction_arr = dataAbstract(weathers, :wind_direction) 
			wind_speed_arr = dataAbstract(weathers, :wind_speed)
			temperature_arr = dataAbstract(weathers, :temperature)
			reg_rainfall = Regression.reg_all(time_arr, rainfall_arr)					
			reg_wind_dir = Regression.reg_all(time_arr, wind_direction_arr)		 
			reg_wind_spd = Regression.reg_all(time_arr, wind_speed_arr)		 
			reg_temp = Regression.reg_all(time_arr, temperature_arr)

			if reg_rainfall == nil || reg_wind_dir == nil || reg_wind_spd == nil || reg_temp == nil
				return []		
			end

			prediction = Prediction.new
			prediction.time = Time.new.to_i+10*60*v
			prediction.rainfall_value = getValue(reg_rainfall, prediction.time)
			prediction.winddir_value = getValue(reg_wind_dir, prediction.time)
			prediction.windspeed_value = getValue(reg_wind_spd, prediction.time)
			prediction.temp_value = getValue(reg_temp, prediction.time)	

			prediction.rainfall_probability = getProbability(reg_rainfall)
			prediction.winddir_probability = getProbability(reg_wind_dir) 
			prediction.windspeed_probability = getProbability(reg_wind_spd) 
			prediction.temp_probability = getProbability(reg_temp) 
			
			predictions.push(prediction)
		end
		#puts "_________get predictions______________"
		#p predictions	
		#p predictions.length
		return predictions	
	end

end