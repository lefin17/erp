class PagesController < ApplicationController
  def index
		@page_title = 'Главная страница'
    if @g_user
      @count_yesterday = Task.tasks(@g_user).current.by_realized_at('yesterday').count('id')
      @count_today = Task.tasks(@g_user).current.by_realized_at('today').count('id')
    end
  end
end
