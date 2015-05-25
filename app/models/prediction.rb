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
	
	def testprint
		p "@@@@@@@@~~~~ test print"
	end
end