require 'statsample'
require 'matrix'

class  Regression

	def self.sillyprint
		puts "~~~print~~~~"
	end

	def self.sum(arr)
		sum=0.0
		arr.each{|val|sum=sum+val.to_f}
		return sum
	end

	def self.sum_product_two_arrs(arr1,arr2)
		n = arr1.length
		arr_p = Array.new
		(0...n).to_a.each do |i|
			arr_p.push(arr1[i]*arr2[i])
		end
		return sum(arr_p)
	end

	def  self.variance_two_arrs(arr1,arr2)
		n = arr1.length
		arr_v = Array.new
		(0...n).to_a.each do |i|
			arr_v.push(arr1[i]-arr2[i])
		end
		return sum_product_two_arrs(arr_v,arr_v)/n
	end

	def self.reg_linear x_arr, y_arr
		begin 
			x_vector = x_arr.to_vector(:scale)
			y_vector = y_arr.to_vector(:scale)
			ds = {'x'=>x_vector, 'y'=>y_vector}.to_dataset
			mlr = Statsample::Regression.multiple(ds,'y')
			#variance
			b = mlr.constant.round(1)
			k = mlr.coeffs["x"].round(1)
			if b.nan? || k.nan?
				return h = {coeff: 0.0, constant: y_arr[0], variance: 0.0, error_flag: false}				
			end					
			y_arr_cal = []
			x_arr.each {|val|y_arr_cal.push(k*val+b)}
			v = variance_two_arrs(y_arr_cal,y_arr).round(1)
			return h = {coeff: k, constant: b, variance: v, error_flag: false}
		rescue
			return h = {error_flag: true}
		end
	end

	def self.reg_polynomial x_arr, y_arr
		begin 
			degree = 3
			x_data = x_arr.map { |x_i| (0..degree).map { |pow| (x_i**pow).to_f } }
			mx =Matrix[*x_data]
			my =Matrix.column_vector(y_arr)
			arr_coe = @coefficients= ((mx.t * mx).inv * mx.t * my).transpose.to_a[0]
			coeffs = @coefficients= ((mx.t * mx).inv * mx.t * my).transpose.to_a[0]
			coeffs.length.times {|i| coeffs[i] = coeffs[i].round(1) }
			constant = coeffs.shift
			coeff = []
			coeffs.each {|v| coeff.unshift(v)}
			#variance
			arr_coe.reverse!
			y_arr_cal = Array.new
			x_arr.each do |val| 
				sum=0
				(0...arr_coe.length).to_a.each do |i|
					sum += arr_coe[i]*(val**(degree-i))
				end
				y_arr_cal.push(sum)
			end
			v = variance_two_arrs(y_arr_cal,y_arr).round(1)
			return h = {coeff: coeff, constant: constant, variance: v, error_flag: false}
		rescue
			return h = {error_flag: true}
		end
	end

	def self.reg_logarithmic x_arr, y_arr	
		log_x_data = x_arr.map { |x| Math.log(x) }
		return reg_linear(log_x_data, y_arr)
	end

	def self.reg_exponential x_arr, y_arr	
		exp_x_data = x_arr.map { |x| Math.exp(x) }
		return reg_linear(exp_x_data, y_arr)
	end

	def self.get_min_v_reg h_arr
		if h_arr.length == 0
			puts "Error: Regression not found"
		else
			h_min_v = h_arr[0]
			h_arr.each do |h|
				if h[:variance] < h_min_v[:variance]
					h_min_v = h
				end
			end
		end
		return h_min_v
	end

	def  self.reg_all x_arr, y_arr
		h_arr = []

		h_ln =  reg_linear(x_arr, y_arr)	
		if h_ln[:error_flag] == false
			h_ln.store(:reg_type, 'linear')
			h_arr.push(h_ln)
		end

		h_p = reg_polynomial(x_arr, y_arr)
		if h_p[:error_flag] == false
			h_p.store(:reg_type, 'polynomial')
			h_arr.push(h_p)
		end

		h_e =  reg_exponential(x_arr, y_arr)
		if h_e[:error_flag] == false
			h_e.store(:reg_type, 'exponential')
			h_arr.push(h_e)
		end

		h_lg = reg_logarithmic(x_arr, y_arr)
		if h_lg[:error_flag] == false
			h_lg.store(:reg_type, 'logarithmic')
			h_arr.push(h_lg)
		end

		#p h_arr
		#puts "=================="
		#p get_min_v_reg(h_arr)

		return get_min_v_reg(h_arr)

	end

end