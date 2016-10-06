# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
	before_filter :get_logged_in_user
  helper_method :current_user

  before_filter :make_action_mailer_use_request_host



  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def current_user
    @g_user ||= get_logged_in_user
    @g_user
  end

protected

  def update_attributes_and_redirect(update_object,
      update_hash,
      options = { :update_redirect => url_for(:action => 'index'),
      :update_render_error => {:action => 'edit'} },
      &proc)
    proc.call(update_object,options) if proc
    if update_object.update_attributes(update_hash)
      flash[:notice] = 'Обновление ...'
      flash[:edited] = params[:id]
      redirect_to options[:update_redirect]
    else
      update_object.reload
      render options[:update_render_error]
    end
  end

  def create_and_redirect(create_object, options =
      { :redirect => url_for(:action => 'index'),
        :render => 'new',
        :flash_notice => 'Добавление ...',
        :flash_error => 'Ошибка ...'
      }, &proc)
    proc.call(create_object) if proc
    if create_object.save
      flash[:notice] = options[:flash_notice]
      if params[:task].present? and params[:task] == 'post'
        redirect_to url_for( :action => 'edit', :id => create_object.id )
      else
        flash[:edited] = create_object.id
        redirect_to options[:redirect]
      end
    else
      flash[:error] = options[:flash_error]
      render :action => options[:render]
    end
  end

  def make_action_mailer_use_request_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end


private

	def get_logged_in_user
		if session[:user_id].blank?
			@g_user = nil
		else
			@g_user = User.get_user(session[:user_id])
		end
	end

	def authorize_admin
		if @g_user.blank? || @g_user.user_type != User::USER_TYPE_ADMIN
			flash[:notice] = 'У вас нет прав доступа к административной части сайта.'
      redirect_to '/'
    end
  end

  def authorize_check
		if (@g_user.blank?) || (not @arrg.include?(@g_user.user_type))
			flash[:notice] = 'У вас нет прав доступа к административной части сайта.'
      redirect_to '/'
    end
  end

	def authorize
		if @g_user.blank?
			flash[:notice] = 'Вы не представились системе.'
      redirect_to :controller => 'user', :action=>'login'
    end
  end

end
