class OrdersController < ApplicationController
include ApplicationHelper
  before_filter :find_order, :only => [:view, :update_payment, :show, :update_status, :transfer, :update, :edit]
	before_filter :authorize
	before_filter :assert_access


	
	def index
    @recipients = User.find :all, :conditions => ['user_type IN(2)'], :order => 'name asc'
    
		@page_title = 'Заказы'

    @filter = OrdersFilter.new(params[:orders_filter])

    unless @g_user.admin?
      @filter.manager_id = @g_user.id 
    end
    @orders = @filter.apply(Order)
    
    @orders = @orders.find(:all).paginate(:page => params[:page], :per_page => 25)



#		conditions = ''
##--------------------------------------------------
#    unless params[:client].nil?
#      conditions += 'user_id = '+params[:client][:cl]
#    end
##--------------------------------------------------
#    unless params[:manager].nil?
#      conditions += 'order_steps.user_id = '+params[:manager]
#    end
##--------------------------------------------------
#		unless params[:s].blank?
#			unless Order::STATUSES.detect{|s| s[1] == params[:s].to_i}.blank?
#				conditions += 'status = ' + params[:s].to_i.to_s
#				@s = params[:s]
#			end
#		end
#		order_by = ''
#		unless params[:sod].blank?
#			case params[:sod]
#			when '1'
#				@sod = 1
#				order_by += 'status asc'
#			when '-1'
#				@sod = -1
#				order_by += 'status desc'
#			end
#		end
#		order_by += (order_by.empty? ? '' : ', ') + 'updated_at desc'
#    if params[:manager].nil?
#      @orders = Order.find :all, :conditions => conditions, :order => order_by
#    else
#      conditions +=' '
#    @orders = Order.find :all,
#       :select => ' DISTINCT orders.*',
#       :conditions => conditions,
#       :order => order_by ,
#       #:joins => ('LEFT OUTER JOIN order_steps ON order_steps.order_id = orders.id')
#       :joins => :order_steps
#    end
	end

	def edit
    unless @order.can_be_edited_by?(current_user)
      flash[:error] = "У вас нет прав для редактирования заказа"
      redirect_to order_path(@order)
    end

		@page_title = 'Редактирование заказа'

		if request.post?
			if @order.update_attributes(params[:order])
				redirect_to order_view_url @order.id
			else
				flash.now[:error] = 'Произошла непонятная ошибка. Сообщите об этом техническим специалистам.'
			end
		end
	end
	
	def print
	  @order = Order.find(params[:id])
	  mode = params[:mode] || 'print'
	  respond_to do |wants|
      wants.html { render :action => mode, :layout => false }
	  end
  end

  def show
    @step = @order.order_steps.new(params[:step])
    @page_title = 'Просмотр заказа №'+@order.id.to_s+'-'+Time.now.strftime('%d.%m.%Y %H:%M ')+'-'+get_item_name_by_id(Order::STATUSES, @order.status)+'-artpolygraf.ru +7 495 6494876'
    @recipients = @order.can_be_transferred_to(current_user)
  end

  def update
    if @order.can_be_edited_by?(current_user)
      if @order.update_attributes(params[:order])
        flash[:notice] = 'Заказ успешно сохранен.'
        redirect_to order_path(@order)
      else
        render :action => :edit
      end
    else
      flash[:error] = 'У вас недостаточно прав для редактирования этого заказа.'
      redirect_to order_path(@order)
    end

  end


  def update_payment
    if [User::USER_TYPE_ADMIN, User::USER_TYPE_BG].include?(current_user.user_type)
      if @order.update_attributes(:payment_flag => params[:order][:payment_flag], :user_l_payment => @g_user.login)
        flash[:notice] = 'Статус оплаты заказа изменен.'
      else
        flash[:error] = "Не удалось изменить статус заказа. Причина: #{@order.errors.full_messages.join('<br />')}."
      end
      redirect_to order_url(@order)
    else
      redirect_to order_url(@order, :status => 403, :error => 'Только бухгалтер или администратор может изменять статус оплаты заказа.')
    end
  end

  def update_status
    @order.status = params[:order][:status]
		if @order.save
			flash[:notice] = "Статус заказа успешно изменен."
	  else
			flash[:error] = "Не удалось изменить статус. Причина: #{@order.errors.full_messages.join('<br />')}"
    end
    redirect_to order_path(@order)
  end

  def transfer
    user = User.find params[:step][:user_id]
    begin
      @order.transfer!(user, current_user, params[:step][:comment])
      flash[:notice] = "Заказ передан пользователю #{user.name}. Пользователь уведомлен по email."
    rescue => e
      logger.error "[OrdersController#transfer] #{e.message}\n\n#{e.backtrace.join("\n")}"
      flash[:error] = "Невозможно передать заказ пользователю #{user.name}. Причина: #{e.message}"
    end
    redirect_to order_path(@order)
  end

	def view
		@order = Order.find params[:id]
    @step = @order.order_steps.new(params[:step])
    @page_title = 'Просмотр заказа №'+@order.id.to_s+'-'+Time.now.strftime('%d.%m.%Y %H:%M ')+'-'+get_item_name_by_id(Order::STATUSES, @order.status)+'-artpolygraf.ru +7 495 6494876'
    laststep = @order.get_current_stage
    if request.post?
			# identify posted form
			case params[:form]
			when 'payments'
				 @order.payment_flag = params[:order][:payment_flag]
				 # @order.user_id_payment = laststep.user_id
				 @order.user_l_payment = @g_user.login
				if @order.save
					redirect_to order_view_url @order.id
				else
					flash.now[:error] = 'Произошла ошибка при изменении флага платежа заказа. Сообщите об этом техническим специалистам.'
				end
			when 'step'
				laststep.comment = params[:step][:comment]
#-------------------------------------------------------    
    @user = User.find(params[:step][:user_id])
#-------------------------------------------------------
				# if last step is not my -- mark as deprived
				if laststep.user_id != @g_user.id
					laststep.is_deprived = true
					laststep.depriver_id = @g_user.id
				else
					laststep.status = OrderStep::STATUS_FORWARDED
				end

				@step.comment = ''		# the comment belongs to previous step

				begin
					@step.transaction() {
						laststep.save!
						@step.save!
						
#-------------------------------------------------
              begin
                    OrdersMailer.deliver_new_order_notification(@order, @user)
                     flash[:notice] = "Почта отправлена"
              rescue => e
                logger.error "[OrdersController#view] #{e.message}\n#{e.backtrace.join("\n")}"
                flash[:error] = "Ошибка отправки почты"
              end
#-------------------------------------------------						
					}
				rescue
					flash.now[:error] = 'Произошла непонятная ошибка при перемещении заказа. Сообщите об этом техническим специалистам.'
				else
					redirect_to order_view_url @order.id
				end

			when 'status'
				@order.status = params[:order][:status]
				if @order.save!
					redirect_to order_view_url @order.id
				else
					flash.now[:error] = 'Произошла непонятная ошибка при перемещении заказа. Сообщите об этом техническим специалистам.'
				end
			end
		else
			# if order not viewed and i am an executor -- mark order as viewed by me
			if laststep.viewed_at.blank? && laststep.user_id == @g_user.id
				if laststep.status == OrderStep::STATUS_WAITING
					laststep.status = OrderStep::STATUS_VIEWED
				end

				laststep.viewed_at = Time.now
				laststep.save
			end
         

			@recipients = nil

			case @g_user.user_type
			when User::USER_TYPE_MANAGER, User::USER_TYPE_ADMIN
				@recipients = User.find(
					:all,
					:conditions => ['(user_type <> ? AND is_inactive = FALSE AND id != ?) OR id = ?',
            User::USER_TYPE_CLIENT, laststep.user_id, @order.user_id.to_s],
					:order => 'login asc'
				)
			else
				# check is this currently my order?
				if laststep.user_id == @g_user.id
					# other users can pass order only to manager
					rutypes = User::USER_TYPE_MANAGER
					@recipients = User.find :all, :conditions => ['(user_type IN(?) AND is_inactive = FALSE)', rutypes]
				end
			end
		end
  end

  def create
    @order = Order.new(params[:order])
    @order.creator = current_user
    if @order.save
      redirect_to order_path(@order)
    else
      render :action => :new
    end
  end

	def new
    @ddd = params
		@page_title = 'Новый заказ'
		@order = Order.new params[:order]
		@login = params[:client]
    if params[:order] and params[:order][:user_id].present?
      @client_name = User.find(params[:order][:user_id])[:name]
    end
    
		if request.post?
			# validations
#-----------------------------------------

 if @order.material_id.blank?
				flash[:error] = "Укажите материал"
				return
			end
			
 if @order.print_method_id.blank?
				flash[:error] = "Укажите способ печати"
				return
			end		
			
 if @order.format_w.blank?
				flash[:error] = "Укажите обрезной формат -  ширину"
				return
			end	
						
		if @order.format_h.blank?
				flash[:error] = "Укажите обрезной формат - высоту"
				return
			end		
					
	
			if params[:order][:user_id].blank?
				flash[:error] = "Укажите клиента"
				return
			end

			@client = User.find_by_id params[:order][:user_id]

			if @client.blank?
				flash[:error] = "Неправильно указан клиент"
				return
			end


			@order = @client.orders.new(params[:order])
			@order.status = Order::STATUS_NEW

			begin
				@order.order_steps.transaction {
					@order.save!

					step1 = {
						:status => OrderStep::STATUS_FORWARDED,
						#:user_id => @client.id,
						:user_id =>  @g_user.id,
						:comment => 'Заказ пользователя.Просмотрен.'
					}

					step2 = {
						:status => OrderStep::STATUS_VIEWED,
						:user_id => @g_user.id,
						:comment => 'Ожидает действия.'
					}

					@order.order_steps.new(step1).save!
					@order.order_steps.new(step2).save!
				}
			rescue
			  # LEXO, WATCH THIS!
        # require 'pp'
        # pp $!
        # pp $!.backtrace
				flash[:error] = "Во время сохранения произошла непонятная ошибка."
				return
			end

			flash[:notice] = "Заказ успешно принят"
			redirect_to orders_url
		end
	end
	
	def destroy
	  Order.destroy(params[:id])
	  
	  respond_to do |wants|
      wants.js {
        render :update do |page|
          page['order-' + params[:id]].remove
        end
      }
    end
  end
  
  
  #-------------------------------------------------------------
def send_mail
  begin
    @order = Order.find params[:id]
    @user = User.find(params[:step][:user_id])

    #@user = User.find(params[id = :user_id]) rescue ''
    #@user = User.find :conditions => ['id = :user_id']

    OrdersMailer.deliver_new_order_notification(@order, @user)
    flash[:notice] = "Почта отправлена"
    respond_to do |format|
      format.html { redirect_to orders_url }
    end
  rescue
    flash[:error] = "Ошибка отправки почты"
  end

 
end
 #-------------------------------------------------------------


private
	def assert_access
		unless can_i_do_it?
			flash[:error] = 'У вас нет прав доступа к этой функции'
			redirect_to '/'
		end
	end

	def can_i_do_it?
		return false if @g_user.blank?
		# return true if [User::USER_TYPE_ADMIN, User::USER_TYPE_MANAGER].include?(@g_user.user_type)
		# FIXME: do security before publishing in internet
		return true
  end

  def find_order
    @order = Order.find params[:id]
  end
end
