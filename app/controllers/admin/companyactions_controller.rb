class Admin::CompanyactionsController < ApplicationController
  def index
    @companyactions = Companyaction.all
  end

  def new
    @companyaction = Companyaction.new
  end

  def create
    @companyaction = Companyaction.new(params[:companyaction])
    create_and_redirect(@companyaction)
  end

  def edit
    @companyaction = Companyaction.find_by_id(params[:id])
  end

  def update
    @companyaction = Companyaction.find_by_id(params[:id])
    update_attributes_and_redirect(@companyaction,params[:companyaction])
  end

  def destroy
    Companyaction.destroy(params[:id])
    redirect_to companyactions_url
  end

end
