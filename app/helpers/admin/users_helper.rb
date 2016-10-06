module Admin::UsersHelper

  def userfroms_for_select
    Userfrom.all.map { |f| [f.aname,f.id] }
  end
  
end
