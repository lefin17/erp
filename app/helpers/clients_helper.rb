module ClientsHelper
  def client_for_select
    User.find(:all, :conditions => ['user_type IN(2)'], :order => 'name asc').collect { |s| [s.name,s.id] }
  end
end
