class Admin::PrintMethodsController < ApplicationController
	layout 'admin'
	before_filter :authorize_admin

  def index
		@page_title = 'Способы печати'
		@pms = PrintMethod.find :all, :order => 'name asc'
  end

  def show
		# stub
  end

  def new
		@pm = PrintMethod.new
		@page_title = 'Новый способ печати'
  end

	def create
		@pm = PrintMethod.new params[:print_method]

    if @pm.save
			flash[:notice] = "Способ печати успешно создан"
      redirect_to admin_print_methods_url
    else
			render :action => "new"
    end
	end

  def edit
		@page_title = 'Изменить способ печати'
		@pm = PrintMethod.find params[:id]
  end

	def update
		@pm = PrintMethod.find params[:id]

		if @pm.update_attributes(params[:print_method])
			flash[:notice] = "Вид продукции успешно изменён"
      redirect_to admin_print_methods_url
		else
			render :action => "edit"
		end
	end

	def destroy
		@pm = PrintMethod.find params[:id]
		@pm.destroy
		redirect_to admin_print_methods_url
	end

end
