class Admin::UserfromsController < ApplicationController

  def index
    @userfroms = Userfrom.all
  end

  def new
    @userfrom = Userfrom.new
  end

  def create
    @userfrom = Userfrom.new(params[:userfrom ])
    create_and_redirect(@userfrom)
  end

  def edit
    @userfrom = Userfrom.find_by_id(params[:id])
  end

  def update
    @userfrom = Userfrom.find_by_id(params[:id])
    update_attributes_and_redirect(@userfrom,params[:userfrom])
  end

  def destroy
    Userfrom.destroy(params[:id])
    redirect_to userfroms_url
  end

end
