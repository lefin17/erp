class MaterialsController < ApplicationController

def deactivate
        if @material = Material.find(params[:id])
                @material.update_attribute(:enabled, 0)
        end
        
#        respond_to do |format|
#                format.js { render :text => '' }
#        end

 wants.js {
  render :update do |page|
 page["material-#{material.id}"].remove
 end
 }
 
end 

 def activate
   if @material = Material.find(params[:id])
      @material.update_attribute(:enabled, 1)
   end   
  end
 
 
 

# respond_to do |format|
#                format.js { render :action => 'index' }
#        end

end