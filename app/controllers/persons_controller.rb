class PersonsController < ApplicationController

    before_filter :authorize
    before_filter :person_find, :only => [:edit,:update]
   # before_filter :assert_access

	# protect_from_forgery :except => ['login_suggest']	# FIXME: remove it and do AJAX with GET request in security reasons!

  def self.per_page
    return 10
  end


	def index
		@page_title = 'Список персон'
		@persons = Person.find :all
		@persons = Person.paginate(:page => params[:page], :per_page => 30)
  end

	def new
		@page_title = 'Новая персона'
		@person = Person.new params[:person]
	end

  def create
    @person = Person.new params[:person]
    create_and_redirect(@person)
  end

	def edit
		@page_title = 'Редактирование персоны'
	end

  def update
    update_attributes_and_redirect(@person, params[:person])
  end


	def show
		@page_title = 'Просмотр персоны'
		@person = Person.find params[:id]
	end

protected

  def person_find
     @person = Person.find(params[:id])
  end

private

	def assert_access
		unless can_i_do_it?
			flash[:error] = 'У вас нет прав доступа к этой функции'
			redirect_to '/'
		end
	end

	def can_i_do_it?
		return false if @g_User.blank?
		return true if [User::User_TYPE_ADMIN, User::User_TYPE_MANAGER].include?(@g_User.User_type)

		return false
	end

end
