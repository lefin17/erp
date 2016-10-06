class Admin::MaterialsController < ApplicationController
	layout 'admin'
	before_filter :authorize_admin

  def index
		@page_title = 'Материалы'
		#@materials = Material.find :all, :order => 'name asc'
		@materials = Material.enabled.find(:all, :order => 'name asc')
  end

  def show
		# stub
  end

  def new
		@material = Material.new
		@page_title = 'Новый материал'
		
  end

	def create
		@material = Material.new params[:material]
		@material.update_attribute(:enabled, 1)
        # @material.enabled => 1

    if @material.save
			flash[:notice] = "Материал успешно создан"
      redirect_to admin_materials_url
    else
			render :action => "new"
    end
	end

  def edit
		@page_title = 'Изменить материал'
		@material = Material.find params[:id]
  end

	def update
		@material = Material.find params[:id]

		if @material.update_attributes(params[:material])
			flash[:notice] = "Материал успешно изменён"
      redirect_to admin_materials_url
		else
			render :action => "edit"
		end
	end

	def destroy
		@material = Material.find params[:id]
		@material.destroy
		redirect_to admin_materials_url
	end

	
 def deactivate
   if @material = Material.find(params[:id])
      @material.update_attribute(:enabled, 0)
   end

  respond_to do |wants|
    wants.js {
      render :update do |page| 
        page["material-#{@material.id}"].remove
      end
    }        
  end
end

 def activate
   if @material = Material.find(params[:id])
      @material.update_attribute(:enabled, 1)
   end   
  end
 

end
