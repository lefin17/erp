class Admin::UsersController < ApplicationController
	layout 'admin'
	before_filter :authorize_admin

  def index
		@page_title = 'Пользователи'
		@users = User.find :all, :conditions => ['user_type != ?', User::USER_TYPE_CLIENT]
  end

	def show
		user = User.find params[:id]

		@page_title = user.login + ' - Пользователи'
		@user = user
	end

	def new
		@page_title = 'Новый пользователь - Пользователи'
		@user = User.new
	end

	def create
		@user = User.new(params[:user])

    if @user.save
			flash[:notice] = "Пользователь успешно создан"
      redirect_to admin_users_url
    else
			render :action => "new"
    end
  end

  def edit
		@page_title = 'Изменить пользователя'
		@user = User.find params[:id]
  end

	def update
		@user = User.find params[:id]

		if @user.update_attributes(params[:user])
			flash[:notice] = "Пользователь успешно изменён"
      redirect_to admin_users_url
		else
			render :action => "edit"
		end
	end

	def destroy
		@user = User.find params[:id]
		@user.destroy
		redirect_to admin_users_url
	end

end
