class TasksController < ApplicationController
  before_filter :authorize
	before_filter :assert_access
  
  before_filter :task_find, :only => [:edit,:update,:show]
  before_filter :onnew, :only => [:new,:create]

  def index
    @uid = params[:user] || 0
    @filter = TasksFilter.new(params[:tasks_filter])
    @tasks = @filter.apply(Task.tasks(@g_user).current)
  
    @count_yesterday = Task.tasks(@g_user).current.by_realized_at('yesterday').count('id')
    @count_today = Task.tasks(@g_user).current.by_realized_at('today').count('id')
    @count_tomorrow = Task.tasks(@g_user).current.by_realized_at('tomorrow').count('id')
    @count_week = Task.tasks(@g_user).current.by_realized_at('week').count('id')
    @count_month = Task.tasks(@g_user).current.by_realized_at('month').count('id')
  end

  def show
    #  Прочитал
    @task.update_attribute('state', 1) if @task.user_id == @g_user.id
    @persons = Person.persons_of_client(@task.client_id)
    @tasks = Task.find(:all, :conditions => ['client_id = ? and id <> ?',@task.client_id,@task.id], :order => 'realized_at')
  end

  def new
    @task = Task.new
    @task.client_id = params[:client] if params[:client]
  end

  def create
    @task = Task.new(params[:task])
    create_and_redirect(@task) do |obj|
      obj[:FIO] = User.find_by_id(params[:task][:user_id])[:fio] || User.find_by_id(params[:task][:user_id])[:login] || "нет данных"
      obj[:fromuser_id] = @g_user.id
    end
  end

  def edit
    @clients = User.clients
    @persons = Person.persons_of_client(@task.client_id)
    @tasks = Task.find(:all, :conditions => ['client_id = ? and id <> ?',@task.client_id,@task.id], :order => 'realized_at')
  end

  def update
    if @g_user.admin? && params[:task][:user_id]
      @task[:FIO] = User.find_by_id(params[:task][:user_id]).name
    end
    if (@task.realized == 0) && (params[:task][:realized] == "1")
        changestate = true
    else
        changestate = false
    end
    if @task.update_attributes(params[:task])
      flash[:notice] = 'Обновление ...'
      if changestate
        begin
          Mail.deliver_event_task_performed(@task)
        rescue
          flash[:error] = "Ошибка отправки почты"          
        end

        if params[:createnext] == 'yes'
          tnew = @task.clone
          tnew.realized = 0
          tnew.realized_at = 3.days.from_now
          tnew.relevance = 0
          tnew.state = 0
          tnew.taskaction_id = 3
          tnew.save
        end
      end
      redirect_to tasks_url
    else
      @task.reload
      render :action => :edit
    end
  end

  def destroy
    Task.destroy(params[:id])
    redirect_to tasks_url
  end

  def get_persons
    @option = Person.find(:all,:conditions => ['user_id=?',params[:id]]).collect { |p| "<option value=#{p.id}>#{p.fio}</option>" }
    render :text => @option
  end

  def history
    @task_performed = Task.tasks(@g_user).performed.by_user(@uid).by_realized_at(params[:show_perfomed]).tasktype(params[:type_perfomed])
  end

protected

  def task_find
    @task = Task.find_by_id(params[:id])
  end

  def onnew
    if params[:client]
      @clients = User.clients.by_id params[:client]
    else
      @clients = User.clients
    end
    @persons = Person.persons_of_client(@clients.first.id) if @clients.present?
  end

private

	def assert_access
		unless can_i_do_it?
			flash[:error] = 'У вас нет прав доступа к этой функции'
			redirect_to '/'
		end
    Task::current_user = @g_user
	end

	def can_i_do_it?
		return false if @g_user.blank?
		# return true if [User::USER_TYPE_ADMIN, User::USER_TYPE_MANAGER].include?(@g_user.user_type)
		# FIXME: do security before publishing in internet
		return true
	end

end
