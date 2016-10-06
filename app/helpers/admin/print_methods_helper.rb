module Admin::PrintMethodsHelper

  def get_printmethods
    PrintMethod.getlist
  end
  
end
