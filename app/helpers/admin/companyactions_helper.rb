module Admin::CompanyactionsHelper
  
  def companyactions_for_select
    Companyaction.all.map { |f| [f.aname,f.id] }
  end
  
end
