class Contactorproducttype < ActiveRecord::Base
  belongs_to :contractor
  belongs_to :product_type
end
