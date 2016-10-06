class Person < ActiveRecord::Base
  has_many :orders
	has_many :order_steps
	has_many :payments
  has_many :tasks
  belongs_to :user


  validates_presence_of :login, :password, :fio
  validates_uniqueness_of :login, :email
  validates_format_of :email, :with => /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.([a-z]){2,4})$/

  named_scope :persons_of_client, lambda { |user_id| {:conditions => ['user_id = ?',user_id]} }

  named_scope :joined, {:include => :user}
  named_scope :like_fio, lambda { |aname| {:conditions => ['persons.fio like ?',"%#{aname}%"]}}
  named_scope :like_client, lambda { |client| {:conditions => ['users.name like ?',"%#{client}%"]}}
  named_scope :like_email, lambda { |email| {:conditions => ['persons.email like ?',"%#{email}%"]}}
  named_scope :like_phone, lambda { |phone| {:conditions => ['persons.phone like ?',"%#{phone}%"]}}

  def name
    self[:fio] || self[:login]
  end

  def self.get_person(id)
		self.find_by_id id
	end
end
