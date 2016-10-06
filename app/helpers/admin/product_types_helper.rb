module Admin::ProductTypesHelper
  def get_producttypes
    ProductType.getlist
  end
end
