class UserController < ApplicationController
  def login
		@page_title = 'Вход в систему'
		if request.post?
			user = User::authorize(params[:login], params[:password])

			if user
				if user.user_type != User::USER_TYPE_CLIENT
					session[:user_id] = user.id
					redirect_to '/'
				else
					flash[:error] = "В данный момент вход в систему от имени клиента не поддерживается :-( Попробуйте чуть позже."
				end
			else
				flash[:error] = "Неверное сочетание логин-пароль"
				redirect_to :controller => 'user', :action=>'login'
			end
		end
  end

	def profile
		@page_title = 'Профиль пользователя'
		@user = @g_user

		if request.post?
			# identify posted form
			case params[:form]
			when 'pdata'			# personal data
				if @user.update_attributes(params[:user])
					flash[:notice] = 'Профиль успешно сохранён'
					redirect_to '/'
				else
					flash.now[:error] = 'Произошла непонятная ошибка. Сообщите об этом техническим специалистам.'
				end

			when 'password'
				if params[:user][:pass].blank?
					@user.errors.add 'pass', 'Введите пароль'
				else
					if params[:user][:pass2].blank?
						@user.errors.add 'pass', 'Введите пароль дважды'
					else
						if params[:user][:pass] != params[:user][:pass2]
							@user.errors.add 'pass', 'Введённые пароли не совпадают'
						else
							@user.pass = params[:user][:pass]
							if @user.save
								flash[:notice] = 'Пароль успешно изменён'
								redirect_to '/'
							else
								flash.now[:error] = 'Произошла непонятная ошибка. Сообщите об этом техническим специалистам.'
							end
						end
					end
				end
			end
		end
	end

  def logout
		session[:user_id] = nil
		redirect_to '/'
  end

end
