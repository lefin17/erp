module UserHelper
  def users_for_select(user_type, show_doselect = false, doselect_text = "Все")
    [[doselect_text,0]] + User.find(:all, :conditions => ['user_type = ?',user_type], :order => 'name asc').collect { |s| [s.login,s.id] }
  end

  def employee_for_select(doselect_text = nil)
    u = User.find(:all, :conditions => ['user_type <> ?',User::USER_TYPE_CLIENT], :order => 'name asc').collect { |s| [s.name || s.login,s.id] }
    unless doselect_text.nil?
        [[doselect_text,0]] + u
    else u
    end
  end

  def managers_for_select
    User.find(:all, :conditions => ['user_type = ?',User::USER_TYPE_MANAGER], :order => 'name asc').collect { |s| [s.name || s.login,s.id] }
  end

end
