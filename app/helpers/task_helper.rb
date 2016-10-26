module TaskHelper

  def client_tasks_for_select(client_id)
    Task.tasks(@g_user).current.by_client(client_id)
  end
  
  def relevance_for_select
    options_for_select([["В рабочем порядке",0],["Важно",1],["Cрочно",2],["Cрочно и важно",3]],0)
  end

  def relevance_class(n)
    ['bk_white','bk_orange','bk_yellow','bk_red'][n]
  end

  def type_for_select(select = nil,doselect_text = "Все")
    u = Task::TASKACTIONS.invert.to_a.sort
  end  

  def period_for_select
    [
      ["За этот Месяц (31 день)","month"],
      ["Вчерашние","yesterday"],
      ["Сегодня","today"],
      ["Завтра","tomorrow"],
      ["Неделя (7 дней)","week"],
      ["За все время", "alltime"],
      ["За прошлый Месяц","prevmonth"],
      ["За позапрошлый Месяц","prevmonth2"],
      ["Текущий квартал", "quarter"],
      #["Заданный", "custom"]
    ]

  end

  def big_period_for_select(select)
     options_for_select([["< 1 месяца","less1"],
         ["> 1 месяца","more1month"],
         ["> 2 месяца","more2month"],
         ["> 3 месяца","more3month"],
         ["> 6 месяца","more6month"],
         ["> 9 месяца","more9month"],
         ["> 12 месяца","more12month"]], select || "less1")
  end
end
