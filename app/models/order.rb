class Order < ActiveRecord::Base
	has_many :order_items
	has_many :order_steps
	has_many :order_postprints
	has_many :postprints, :through => :order_postprints
    
    #---------------------------------
    
    #--------------------------------- 	
	accepts_nested_attributes_for :postprints, :allow_destroy => true

	belongs_to :product_type
	belongs_to :print_method
	belongs_to :material
	belongs_to :contractor

	belongs_to :user
  belongs_to :manager, :class_name => 'User'
  belongs_to :creator, :class_name => 'User'

  named_scope :later_than, lambda { |date| {:conditions => ["#{table_name}.created_at >= ?", date]} }
  named_scope :earlier_than, lambda { |date| {:conditions => ["#{table_name}.created_at <= ?", date ]} }
  named_scope :by_manager, lambda { |manager_or_id| {
      :conditions => {:order_steps => {:user_id => manager_or_id.is_a?(User) ? manager_or_id.id : manager_or_id }},
      :joins => :order_steps
  }}
  named_scope :by_client, lambda {|client_or_id| {:conditions => {:user_id => client_or_id.is_a?(User) ? client_or_id.id : client_or_id }}}
  named_scope :with_status, lambda {|status| {:conditions => {:status => status}}}
  named_scope :ordered_by, lambda {|column, direction| {:order => "#{column} #{direction}"}}
	
	# after_save :deliver_create_notification

	# новый
	STATUS_NEW = 0
	# в обработке
	STATUS_INPROCESS = 1
	# на утверждении
	STATUS_IN_APPROVE = 2
	# в печати
	STATUS_IN_PRINTING = 3
	# прерван
	STATUS_BROKEN = 4
	# выполнен
	STATUS_DONE = 5
	# сдан
	STATUS_RELEASED = 6
	# к получению
	STATUS_IN_RECEIVING = 7

	# order statuses
	STATUSES = [['Новый', STATUS_NEW],
							['В обработке',	STATUS_INPROCESS],
							['На утверждении',	STATUS_IN_APPROVE],
							['В печати',	STATUS_IN_PRINTING],
							['К получению',	STATUS_IN_RECEIVING],
							['Прерван', STATUS_BROKEN],
							['Выполнен', STATUS_DONE],
							['Сдан', STATUS_RELEASED]]

	# не оплачено
	PAYMENT_FLAG_NOT_PAYED = 0
	# оплачено
	PAYMENT_FLAG_PAYED = 1	
	# предоплата
	PAYMENT_PREPAYED = 2
	# залог
	PAYMENT_PLEDGE = 3
	# внутренний заказ
	PAYMENT_INTERNAL = 4
	#отсрочка 45
	PAYMENT_DELAY_45 = 5
	#отсрочка 30
	PAYMENT_DELAY_30 = 6
	#отсрочка 15
	PAYMENT_DELAY_15 = 7	
	

	PAYMENT_FLAGS = [['<font style="color:red;">Не оплачено</font>', PAYMENT_FLAG_NOT_PAYED],
                   ['Оплачено', PAYMENT_FLAG_PAYED],
                   ['Предоплата', PAYMENT_PREPAYED],
                   ['Залог', PAYMENT_PLEDGE],
                   ['Внутренний Заказ', PAYMENT_INTERNAL],
                   ['Отсрочка 45 дней', PAYMENT_DELAY_45],
                   ['Отсрочка 30 дней', PAYMENT_DELAY_30],
                   ['Отсрочка 15 дней', PAYMENT_DELAY_15]]
    
    PAYMENT_FLAGS_MANAGER = [['<font style="color:red;">Не оплачено</font>', PAYMENT_FLAG_NOT_PAYED],
                   ['Предоплата', PAYMENT_PREPAYED],
                   ['Залог', PAYMENT_PLEDGE],
                   ['Внутренний Заказ', PAYMENT_INTERNAL],
                   ['Отсрочка 45 дней', PAYMENT_DELAY_45],
                   ['Отсрочка 30 дней', PAYMENT_DELAY_30],
                   ['Отсрочка 15 дней', PAYMENT_DELAY_15]]
               

  validates_presence_of :user_id, :material_id, :print_method_id
  validates_numericality_of :format_h, :only_integer => true, :allow_nil => false, :greater_than => 0
  validates_numericality_of :format_w, :only_integer => true, :allow_nil => false, :greater_than => 0
  validates_numericality_of :circulation, :only_integer => true, :allow_nil => true, :greater_than => 0
  validates_numericality_of :material_density, :allow_nil => true, :greater_than => 0

  after_create :create_steps

  def manager
    if self.manager_id.present?
      User.find self.manager_id
    else
      self.creator
    end
  end
  def get_current_stage
		self.order_steps.find :first, :order => 'created_at desc'
  end
  alias :current_step :get_current_stage

  def has_bill?
    self[:bill_no].present?
  end

  def bill_no
    self[:bill_no].present? ? self[:bill_no] : "нет счета"
  end

  def bill_date_raw
    self[:bill_date]
  end
  def bill_date
    self[:bill_date].present? ? self[:bill_date].to_formatted_s(:long) : "нет даты счета"
  end

  def print_format
    "[#{format_w}x#{format_h}]"
  end

  def whoprint
    self[:is_mysqlf_print_method] ? "Печатаем сами" : "Печатает контрагент"
  end

  def printmethod
    self.print_method.present? ? self.print_method.name : "не задан"
  end

  def postprint
    pp = ""
    pp << "Резка " if self.pp_cutting
    pp << "Ламинация(#{self.pp_lamination_tag}) " if self.pp_lamination
    pp << "Сборка" if self.pp_composition
    pp << "Фольгирование " if self.pp_foiling
    pp << "Пружина " if self.pp_spring
    pp << "Переплёт " if self.pp_twining
    pp << "Фальцовка(#{self.pp_falze_tag}) " if self.pp_falze
    pp << "Биговка(#{self.pp_bigging_tag}) " if self.pp_bigging
    pp << "Скругление углов" if self.pp_rounding
    pp
  end

  def self.available_design_tasks
    ['дизайн', 'внесение правок', 'корректор', 'набор текста', 'отрисовка',
     'сканирование',  'ретушь', 'цветокррекция', 'фотосъемка', 'цветопроба', 'спуск полос']
  end

  def self.available_antimarker_products
    ['1-а-131', '1-а-130', '1-а-129', '1-а-128', '1-а-127', '1-а-126', '1-а-125', '1-а-124', '1-а-123', '1-а-122', '1-а-121', '1-а-120', '1-а-119', '1-а-118', '1-а-117', '1-а-116', '1-а-115', '1-а-114', '1-а-113', '1-а-112', '1-а-111', '1-а-110', '1-а-109', '1-а-108', '1-а-107', '1-а-106', '1-а-105', '1-а-104', '1-а-103', '1-а-102', '1-а-101']
  end
  
  def self.available_antimarker_2_products
    ['2-а-247', '2-а-246', '2-а-245', '2-а-244', '2-а-243', '2-а-242', '2-а-241', '2-а-240', '2-а-239', '2-а-238', '2-а-237', '2-а-236', '2-а-235', '2-а-234', '2-а-233', '2-а-232', '2-а-231', '2-а-230', '2-а-229', '2-а-228', '2-а-227', '2-а-226', '2-а-225', '2-а-224', '2-а-223', '2-а-222', '2-а-221', '2-а-220', '2-а-219', '2-а-218', '2-а-217', '2-а-216', '2-а-215', '2-а-214', '2-а-213', '2-а-212', '2-а-211', '2-а-210', '2-а-209', '2-а-208', '2-а-207', '2-а-206', '2-а-205', '2-а-204', '2-а-203', '2-а-202', '2-а-201']
  end
  
    def self.available_antimarker_3_products
    ['3-а-327', '3-а-326', '3-а-325', '3-а-324', '3-а-323', '3-а-322', '3-а-321', '3-а-320', '3-а-319', '3-а-318', '3-а-317', '3-а-316', '3-а-315', '3-а-314', '3-а-313', '3-а-312', '3-а-311', '3-а-310', '3-а-309', '3-а-308', '3-а-307', '3-а-306', '3-а-305', '3-а-304', '3-а-303', '3-а-302', '3-а-301', '2-а-220', '2-а-219', '2-а-218', '2-а-217', '2-а-216', '2-а-215', '2-а-214', '2-а-213', '2-а-212', '2-а-211', '2-а-210', '2-а-209', '2-а-208', '2-а-207', '2-а-206', '2-а-205', '2-а-204', '2-а-203', '2-а-202', '2-а-201']
  end
  
  def self.available_doorfix_products
  ['d001', 'd002', 'd003', 'd004', 'd005', 'd006', 'd007', 'd008', 'd009', 'd010', 'd011', 'd012', 'd013', 'd014', 'd015', 'd016', 'd017', 'd018', 'd019', 'd020', 'd021', 'd022', 'd023', 'd024', 'd025', 'd026', 'd027', 'd028', 'd029', 'd030', 'd031', 'd032', 'd033', 'd034', 'd035', 'd036', 'd037', 'd038', 'd039', 'd040', 'd041', 'd042', 'd043', 'd044', 'd045', 'd046', 'd047', 'd048', 'd049', 'd050']
  end
  
    def self.available_B000_products
  ['B401', 'B402', 'B403', 'B404', 'B405', 'B406', 'B407', 'B408', 'B409', 'B410', 'B411', 'B412', 'B413', 'B414', 'B415', 'B416', 'B417', 'B418', 'B419', 'B420', 'B421', 'B422', 'B423', 'B424', 'B425', 'B426', 'B427', 'B428', 'B429', 'B430', 'B431', 'B432', 'B433', 'B434', 'B435', 'B436', 'B437', 'B438', 'B439', 'B440']
  end
  
  def self.locations
    [
      ['Офис', 'office'],
      ['Склад', 'warehouse'],
      ['Доставка', 'delivery'],
      ['Трансп-комп ПЭК','trans-pak'],
      ['Автотрейдинг','autotrejding'],
      ['Байкал-сервис','bajkal-service'],
      ['Деловые линии','delov-line']
    ]
  end

  def delivering
    if self[:is_delivering]
      s = "требуется доставка"
      if self[:delivery_to]
        s << "Адрес доставки: #{self[:delivery_to]}"
      else
        s << "Адрес доставки: не указан"
      end
    else
      s = "без доставки"
    end
  end

  def colorprobe
    if self[:colorprobe]
      s = "нужна цветопроба"
    else
      s = "не требуется"
    end
  end

  def can_be_edited_by?(user)
    if self.status == Order::STATUS_NEW
      user.admin? || (user.manager? && user.id == self.manager.id)
    else
      user.admin?
    end
  end

  def can_be_transferred_to(user)
    if user.admin? || (user.manager? && user.id == self.manager.id)
      User.staff.find(:all, :conditions => ["id NOT IN (?)", [user.id, self,current_step.user_id]])
    elsif current_step.user_id == user.id
      User.admins + User.managers - [user]
    else
      []
    end
  end

  def owner?(user)
    current_step.user_id = user.id
  end

  def transfer!(to_user, by_user, comment = '')
    self.transaction do
      self.lock!
      last_step = current_step
      last_step.comment = comment
      if owner?(by_user)
        last_step.status = OrderStep::STATUS_FORWARDED
      else
        last_step.is_deprived = true
			  last_step.depriver_id = by_user.id
      end
      last_step.save!
      self.order_steps.create!(:user_id => to_user.id)
      if self.status == STATUS_NEW && [User::USER_TYPE_MANAGER, User::USER_TYPE_ADMIN].exclude?(to_user.user_type)
        self.status = STATUS_INPROCESS
        self.save!
      end
      OrdersMailer.deliver_new_order_notification(self, to_user)
    end
  end


  protected
    def create_steps
      step1 = {
          :status => OrderStep::STATUS_FORWARDED,
          #:user_id => @client.id,
          :user_id =>  self.creator.id,
          :comment => 'Заказ пользователя.Просмотрен.'
        }

        step2 = {
          :status => OrderStep::STATUS_VIEWED,
          :user_id => self.creator.id,
          :comment => 'Ожидает действия.'
        }

        self.order_steps.new(step1).save!
        self.order_steps.new(step2).save!
    end
    
end
