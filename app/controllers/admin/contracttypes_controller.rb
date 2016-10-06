class Admin::ContracttypesController < ApplicationController

  def index
    @contracttypes = Contracttype.all
  end

  def new
    @contract = Contracttype.new
  end

  def create
    @contract = Contracttype.new(params[:contracttype])
    create_and_redirect(@contract)    
  end

  def edit
    @contract = Contracttype.find_by_id(params[:id])    
  end

  def update
    @contract = Contracttype.find_by_id(params[:id])
    update_attributes_and_redirect(@contract,params[:contracttype])    
  end

  def destroy
    Contracttype.destroy(params[:id])
    redirect_to contracttypes_url
  end
  
end
