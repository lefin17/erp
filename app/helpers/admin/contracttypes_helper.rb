module Admin::ContracttypesHelper
  
  def contracttypes_for_select
    Contracttype.all.map { |f| [f.aname,f.id] }
  end

  def contracttypes_default
    id = Contracttype.getdefaultfield.first
    id ? id.id : 0
  end

end
