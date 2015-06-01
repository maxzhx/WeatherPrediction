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
	
	#def self.testprint
	#	p "@@@@@@@@~~~~ test print"
	#end

	# get relative time array from weathers
	def self.timeAbstract weathers, now_ts
		arr = []
		weathers.each {|v| arr.push(v[:date].to_i - now_ts)}
		return arr
	end

	# get corresponding data array from weathers , for example rainfall data array
	def self.dataAbstract weathers, key	
		arr = []
		weathers.each {|v| arr.push(v[key])}
		return arr
	end

	# get value from formula and key
	def self.getValue reg, time
		if reg[:reg_type] == 'linear'
			#puts "getting linear value ..."	
			return (reg[:coeff]*time+reg[:constant]).round(1)
		elsif reg[:reg_type] == 'polynomial'
			#puts "getting polynomial value ..."
			value = 0
			coeffs = reg[:coeff]
			coeffs.each_index do |i|
				value +=coeffs[i]*(time**(coeffs.length-i))
			end
			return (value+reg[:constant]).round(1)
		elsif reg[:reg_type] == 'exponential'
			#puts "getting exponential value ..."
			#p reg[:coeff]
			#p reg[:coeff].class
			#p reg[:constant]
			#p reg[:constant].class
			#p Math.exp(time)
			return (reg[:coeff]*Math.exp(time)+reg[:constant]).round(1)
		elsif reg[:reg_type] == 'logarithmic'
			#puts "getting logarithmic value ..."
			return (reg[:coeff]*Math.log(time)+reg[:constant]).round(1)
		end
	end

	def self.getProbability reg
		return (1/(reg[:variance]+1)).round(2)
	end

	#get prediction data from weathers and period by get the best fit regression
	def self.predict weathers, period
		puts " - ~~~~~~~Prediction start~~~~~~~"
		puts " - number of data for regression: #{weathers.length}"
		puts " - period: #{period}"
		#get best fit regressions
		now_ts = Time.new.to_i
		time_arr = timeAbstract(weathers, now_ts) 	
		rainfall_arr = dataAbstract(weathers, :rainfall) 
		wind_direction_arr = dataAbstract(weathers, :wind_direction) 
		wind_speed_arr = dataAbstract(weathers, :wind_speed)
		temperature_arr = dataAbstract(weathers, :temperature)
		puts "======rainfall prediction======="
		p time_arr
		p rainfall_arr
		reg_rainfall = Regression.reg_all(time_arr, rainfall_arr)
		puts "======winddir prediction======="
		p time_arr
		p wind_direction_arr			
		reg_wind_dir = Regression.reg_all(time_arr, wind_direction_arr)
		puts "======windspd prediction======="
		p time_arr
		p wind_speed_arr	 
		reg_wind_spd = Regression.reg_all(time_arr, wind_speed_arr)	
		puts "======temp prediction======="	
		p time_arr
		p  temperature_arr
		reg_temp = Regression.reg_all(time_arr, temperature_arr)
		if reg_rainfall == nil || reg_wind_dir == nil || reg_wind_spd == nil || reg_temp == nil
			return []		
		end

		predictions = []
		(period.to_i/10+1).times do |v|
			prediction = Prediction.new
			ts = 10*60*v
			#get prediction time
			prediction.time = now_ts+10*60*v
			# get prediction values
			prediction.rainfall_value = getValue(reg_rainfall, ts)
			winddir_value =  getValue(reg_wind_dir, ts)
			if winddir_value > 360
				prediction.winddir_value = winddir_value - 360
			else
				prediction.winddir_value = winddir_value 
			end
			prediction.windspeed_value = getValue(reg_wind_spd, ts)
			prediction.temp_value = getValue(reg_temp, ts)	
			# get prediction probabiliies
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