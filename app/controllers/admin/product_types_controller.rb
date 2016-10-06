class Admin::ProductTypesController < ApplicationController
	layout 'admin'
	before_filter :authorize_admin

  def index
		@page_title = 'Виды продукции'
		@pts = ProductType.find :all, :order => 'name asc'
  end

  def show
		# stub
  end

  def new
		@pt=  ProductType.new
		@page_title = 'Новый вид продукции'
  end

	def create
		@pt = ProductType.new params[:product_type]

    if @pt.save
			flash[:notice] = "Вид продукции успешно создан"
      redirect_to admin_product_types_url
    else
			render :action => "new"
    end
	end

  def edit
		@page_title = 'Изменить вид продукции'
		@pt = ProductType.find params[:id]
  end

	def update
		@pt = ProductType.find params[:id]

		if @pt.update_attributes(params[:product_type])
			flash[:notice] = "Вид продукции успешно изменён"
      redirect_to admin_product_types_url
		else
			render :action => "edit"
		end
	end

	def destroy
		@pt = ProductType.find params[:id]
		@pt.destroy
		redirect_to admin_product_types_url
	end

end
