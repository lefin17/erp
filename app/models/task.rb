class Task < ActiveRecord::Base
  validates_presence_of :user_id,:fromuser_id,
    :FIO,:relevance,:taskaction_id,:realized_at

  validate :validate_key_order_person
  validate :validate_realized


  cattr_accessor :current_user

  TASKACTIONS = {
    1 => "Звонок",
    2 => "Письмо",
    3 => "email",
    4 => "Посылка",
    5 => "Рассылка",
    6 => "Факс",
    7 => "Личная встреча",
    8 => "Презентация",
    9 => "Выставить счет",
    10 => "Доставка",
    11 => "Поручение"
  }

  RELEVANCE = ["В рабочем порядке","Важно","Cрочно","Cрочно и важно"]

  belongs_to :user
  belongs_to :client, :class_name => "User", :foreign_key => 'client_id'
  belongs_to :from_user, :class_name => "User", :foreign_key => 'fromuser_id'
  belongs_to :person
  belongs_to :taskaction

  named_scope :tasks, lambda { |user| 
    u = { :order => 'realized_at, relevance desc'}
    u = { :conditions => { :user_id => user.id } }.update(u) unless user.admin?
    u
  }

  named_scope :current, {:conditions => 'realized = 0'}
  named_scope :performed, {:conditions => 'realized = 1'}

  named_scope :by_client, lambda { |client_id| {:conditions => ['client_id = ?',client_id]} }

  named_scope :by_user, lambda {|user_id|
    { :conditions => ['user_id = ?',user_id] } if user_id.to_i > 0
  }



  named_scope :by_realized_at, lambda { |show|
    date = Time.now.to_date
    case show
    when 'yesterday'
      {:conditions => ['realized_at < ?',date]}
    when 'today'
      {:conditions => ['date(realized_at) = ?',date]}
    when 'tomorrow'
      {:conditions => ['date(realized_at) = ?',date+1]}
    when 'week'
      {:conditions => ['date(realized_at) between ? and ?',date, date+7]}
    when 'month'
      {:conditions => ['date(realized_at) between ? and ?',date, date+31]}
#     Если надо стриого месяц с 01 ... 31
#     {:conditions => ['date(realized_at) between ? and ?',Time.mktime(date.year, date.month, 1), Time.mktime(date.year, date.month, Time.days_in_month(date.month, date.year))]}
    when 'less1'
      {:conditions => ['date(realized_at) <= ?',date >> 1]}
    when 'more1month'
      {:conditions => ['date(realized_at) >= ?',date >> 1]}
    when 'more2month'
      {:conditions => ['date(realized_at) >= ?',date >> 2]}
    when 'more3month'
      {:conditions => ['date(realized_at) >= ?',date >> 3]}
    when 'more6month'
      {:conditions => ['date(realized_at) >= ?',date >> 6]}
    when 'more9month'
      {:conditions => ['date(realized_at) >= ?',date >> 9]}
    when 'more12month'
      {:conditions => ['date(realized_at) >= ?',date >> 12]}
    end    
  }

  named_scope :tasktype, lambda {|type| {:conditions => ['taskaction_id = ?',type]} if type.to_i > 0 } 
  named_scope :later_than, lambda { |date| {:conditions => ['realized_at >= ?', date]} }
  named_scope :earlier_than, lambda { |date| {:conditions => ['realized_at <= ?', date ]} }
  

  def can_edit?
    self[:fromuser_id] == current_user.id or self[:user_id] == current_user.id or current_user.admin?
  end

  def validate_realized
     errors.add_to_base("Нельзя принять задачу, не заполнив поле Результат выполнения") if self[:realized] == 1 and not self[:result].present?
  end
  
  def validate_key_order_person
    client = Person.find_by_id(self.person_id)
    unless client and (client['user_id'].to_i == self.client_id.to_i)
      errors.add_to_base("Персона не пренадлежит клиенту.")
    end
    errors.add_to_base("Не задан клиент") unless self.client_id
    errors.add_to_base("Введите суть действия") if self.subject.blank?
  end

  def taskaction
    Task::TASKACTIONS[self.taskaction_id] unless self.nil?
  end

  def client_name
    self.client ? self.client.name : 'Пусто'
  end

  def person_name
    self.person ? self.person.name : 'Пусто'
  end

  def status
    result = "Новый"
    result = "Прочитан" if self[:state] == 1
    result = "Выполнен" if self[:realized] == 1
    result
  end

  def relevance_name
   RELEVANCE[self[:relevance]]
  end
 
end
