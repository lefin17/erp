class ProductType < ActiveRecord::Base
	has_many :orders

  named_scope :getlist, { :order => 'name asc' }

  default_scope :order => 'name asc'

	def self.get_list
		self.getlist
	end
end
