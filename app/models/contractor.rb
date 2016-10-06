class Contractor < ActiveRecord::Base
	has_many :orders
  has_many :contractorprintmethods, :dependent => :destroy
  has_many :print_methods, :through => :contractorprintmethods
  has_many :contactorproducttypes, :dependent => :destroy
  has_many :product_types, :through => :contactorproducttypes
  
	def self.get_list
		self.find :all, :order => 'name asc'
	end

  def show_print_methods
    self.print_methods.map{ |p| p.name  }.join(', ')    
  end

  def show_product_types
    self.product_types.map{ |p| p.name  }.join(', ')
  end
  
end
