class User < ActiveRecord::Base
	has_many :orders
	has_many :order_steps
	has_many :payments
# один клиент может иметь много персон	
  has_many :persons
  has_many :tasks

  has_one :clientpapa, :class_name => 'User',
    :foreign_key => 'owner_id'
  belongs_to :owner, :class_name => "User"
  belongs_to :contracttype
  belongs_to :companyaction
  belongs_to :userfrom



	# администратор
	USER_TYPE_ADMIN = 1
	# клиент
	USER_TYPE_CLIENT = 2
	# менеджер
	USER_TYPE_MANAGER = 3
	# дизайнер
	USER_TYPE_DESIGNER = 4
	# печатник
	USER_TYPE_PRINTER = 5
	# бухгалтер
	USER_TYPE_BG = 6
	# логист
	USER_TYPE_LG = 7

	# user types
	USER_TYPES = [['Администратор', USER_TYPE_ADMIN],
								['Клиент', USER_TYPE_CLIENT],
								['Менеджер', USER_TYPE_MANAGER],
								['Дизайнер', USER_TYPE_DESIGNER],
								['Печатник', USER_TYPE_PRINTER],
								['Бухгалтер', USER_TYPE_BG],
								['Логист', USER_TYPE_LG]]

  named_scope :clients, {:include => [:contracttype, :companyaction, :userfrom],
    :conditions => ['user_type = ?',USER_TYPE_CLIENT]}
  named_scope :order, lambda { |sort_column,sort_direction| {:order => "#{sort_column} #{sort_direction}"} if sort_column.present? }
  named_scope :by_id, lambda {|user_id| {:conditions => ['id = ?',user_id]} }

#  Для фильтров диалога
  named_scope :like_name, lambda { |aname| {:conditions => ['name like ?',"%#{aname}%"]} unless aname.blank? }
  named_scope :like_ur, lambda { |ur| {:conditions => ['jur_name like ?',"%#{ur}%"]} unless ur.blank? }
  named_scope :like_email, lambda { |email| {:conditions => ['email like ?',"%#{email}%"]} unless email.blank? }
  named_scope :like_phone, lambda { |phone| {:conditions => ['phone like ?',"%#{phone}%"]} unless phone.blank? }
  named_scope :by_manager, lambda { |manager_id| {:conditions => ['owner_id = ?', manager_id]} unless manager_id.blank? }

    %w(admin client manager designer printer accountant logistician).each_with_index do |type, value|
      named_scope "#{type}s".to_sym, :conditions => {:user_type => value + 1 }
      class_eval %{
        def #{type}?
          self.user_type == #{value+1}
        end
     }
    end
  named_scope :staff, :conditions => ["user_type != ?", USER_TYPE_CLIENT]
  def name
    self[:name] || self[:login] || "нет клиента"
  end

	def pass
		# pas is for set only
		''
	end

	def pass=(pwd)
		self.password = Digest::MD5.hexdigest(pwd)
	end

	def validate
    errors.add(:login, 'Не указан логин') if login.blank?
    unless login.blank?
      errors.add(:login, 'Логин должен содержать только маленькие латинские буквы') unless login =~ /^[a-z]+[a-z0-9]*$/
      errors.add(:login, 'Логин пользователя не может быть больше 20 символов') if login.mb_chars.length > 20
      errors.add(:login, 'Логин пользователя должен быть уникальным') if self.login_changed? && !User.find_by_login(login).blank?
    end

    if user_type == User::USER_TYPE_CLIENT
      errors.add(:phone, 'Не указан телефон') if phone.blank?
    end
    
    errors.add(:email, 'Не указан email') if email.blank?
    errors.add(:email, 'Неправильно указан email') unless email =~ /^[0-9a-z][0-9a-z.\-_\+]*[0-9a-z\-_]?@[a-z0-9_.\-]+\.[a-z]{2,7}$/i

    unless jur_name.blank?
      errors.add(:jur_name, 'Юр. лицо должно содержать только русские буквы') unless jur_name.mb_chars =~ /^[а-яА-Я0-9" ]*$/
    end
	end

	# авторизация пользователя
	def self.authorize(login, password)
		user = self.find_by_login(login)

		if user
			if user.password == Digest::MD5.hexdigest(password)
				return user
			end
		end
		return nil
	end

	def self.get_user(id)
		self.find_by_id id
	end

  def style_color
    color = self[:color] || '#FFFFFF'
    "style='background-color: #{color}'"
  end

  def contracttype_name
     self.contracttype.aname if self.contracttype
  end

  def companyaction_name
    self.companyaction.aname if self.companyaction
  end

  def userfrom_name
    self.userfrom.aname if self.userfrom
  end

  def fullinfo
    "Юр. лицо: #{self.jur_name} |
    Юр. адрес: #{self.jur_address} |
    ИНН: #{self.jur_inn} |
    КПП: #{self.jur_kpp} |
    Счёт №: #{self.jur_account} |
    Р/С: #{self.jur_account} |
    БИК: #{jur_bik} | 
    Банк: #{self.jur_bank} | 
    Телефон: #{self.phone}
    Мобильный: #{self.phone_mobile} |
    Фактический адреc: #{self.adress_fact} |
    Адрес доставки: #{self.adress_delivery} |
    Сайт: #{self.email}
    Email: #{self.user_site} "
  end

end
