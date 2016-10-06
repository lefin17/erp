class Admin::ContractorsController < ApplicationController
	layout 'admin'
#	before_filter :authorize_admin
	before_filter :authorize_check

  def index
		@page_title = 'Контрагенты'
		@cas = Contractor.find :all, :order => 'name asc'
  end

  def show
		# stub
  end

  def new
		@ca = Contractor.new
		@page_title = 'Новый контрагент'
  end

	def create
		@ca = Contractor.new params[:contractor]
    if @ca.save

      if params[:contractor][:contractorprintmethod_id]
        @pd = PrintMethod.find(params[:contractor][:contractorprintmethod_id])
        @ca.contractorprintmethods.destroy_all
        @ca.print_methods << @pd
      end

      if params[:contractor][:contactorproducttype_id]
        @pt = ProductType.find(params[:contractor][:contactorproducttype_id])
        @ca.contactorproducttypes.destroy_all
        @ca.product_types << @pt
      end


			flash[:notice] = "Контрагент успешно создан"
      redirect_to admin_contractors_url
    else
			render :action => "new"
    end
	end

  def edit
		@page_title = 'Изменить контрагента'
		@ca = Contractor.find params[:id]
  end

	def update
		@ca = Contractor.find params[:id]
		if @ca.update_attributes(params[:contractor])

      @pd = PrintMethod.find(params[:contractor][:contractorprintmethod_id])
      @ca.contractorprintmethods.destroy_all
      @ca.print_methods << @pd
      
      @pt = ProductType.find(params[:contractor][:contactorproducttype_id])
      @ca.contactorproducttypes.destroy_all
      @ca.product_types << @pt

			flash[:notice] = "Контрагент успешно изменён"
      redirect_to admin_contractors_url
		else
			render :action => "edit"
		end
	end

	def destroy
		@ca = Contractor.find params[:id]
		@ca.destroy
		redirect_to admin_contractors_url
	end

  protected

  def authorize_check
    @arrg = [User::USER_TYPE_ADMIN,User::USER_TYPE_MANAGER]
    super
  end

end
