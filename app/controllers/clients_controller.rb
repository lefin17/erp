class ClientsController < ApplicationController
	before_filter :authorize
	before_filter :assert_access
	protect_from_forgery :except => ['login_suggest']	# FIXME: remove it and do AJAX with GET request in security reasons!

  helper_method :sort_column, :sort_direction

	def index
		@page_title = 'Список клиентов'
		@clients = User.clients.order(sort_column,sort_direction).like_name(params[:f_name]).
      like_ur(params[:f_ur]).
      like_email(params[:f_email]).
      like_phone(params[:f_phone]).
      by_manager(params[:f_manager_id]).
      find(:all, :include => [:contracttype, :companyaction])
    @f_name,@f_ur,@f_email,@f_phone, @f_manager_id = params[:f_name], params[:f_ur], params[:f_email], params[:f_phone], params[:f_manager_id]
    @managers = User.managers.find(:all,
      :select => "#{User.table_name}.id, #{User.table_name}.name, #{User.table_name}.login, COUNT(clients.id) as clients_count",
      :joins  => "LEFT JOIN #{User.table_name} clients ON #{User.table_name}.id = clients.owner_id",
      :group  => "#{User.table_name}.id"
    )
   # @clients = @clients.paginate(:page => params[:page], :per_page => 30)

  end

	def login_suggest
		@items = User.find(
			:all,
			:conditions => ['user_type = ? AND LOWER(login) LIKE ?', User::USER_TYPE_CLIENT, '%' + params[:client][:login].downcase + '%' ],
			:limit => 10
		)
		render :inline => "<%= auto_complete_result(@items, 'login') %>"
	end

def name_suggest
		@items = User.find(
			:all,
			:conditions => ['user_type = ? AND LOWER(name) LIKE ?', User::USER_TYPE_CLIENT, '%' + params[:client][:name].downcase + '%' ],
			:limit => 10
		)
		render :inline => "<%= auto_complete_result(@items, 'name') %>"
	end

  def new
		@page_title = 'Новый клиент'
		@client = User.new params[:client]
		@client.user_type = User::USER_TYPE_CLIENT
		@client.pass = ''

		if request.post?
      @client.owner_id = @g_user.id
			if @client.save
				flash[:notice] = 'Клиент успешно создан'
				redirect_to client_view_url @client
			end
		end
	end

	def view
		@page_title = 'Просмотр клиента'
		@client = User.find params[:id]
    @person = Person.find(:all,:conditions => ['user_id = '+params[:id]])
    @tasks = Task.tasks(@g_user).current.by_client(params[:id])
	end

	def edit
		@page_title = 'Редактирование клиента'
		@client = User.find params[:id]

		if request.post?
			if @client.update_attributes(params[:client])
				flash[:notice] = 'Клиент успешно сохранен'
				redirect_to client_view_url @client
			end
		end
	end

private

  def sort_column
#    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
    params[:sort]
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


	def assert_access
		unless can_i_do_it?
			flash[:error] = 'У вас нет прав доступа к этой функции'
			redirect_to '/'
		end
	end

	def can_i_do_it?
		return false if @g_user.blank?
		return true if [User::USER_TYPE_ADMIN, User::USER_TYPE_MANAGER].include?(@g_user.user_type)

		return false
	end

end
