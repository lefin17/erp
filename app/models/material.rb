class Material < ActiveRecord::Base
	has_many :orders
	named_scope :enabled, :conditions => { :enabled => true }
	# фильтр для деактивированных материалов
   

	def self.get_list
		# self.find :all, :order => 'name asc'
		  self.find :all, :order => 'name asc'
	end

end
