class PrintForm < ActiveRecord::Base
  serialize :can_be_accessed_by

  validate :validate_user_types

  named_scope :by_printable_type, lambda { |type|
    value = if type.is_a?(Class)
      type.name
    elsif type.is_a?(String)
      type
    elsif type.is_a?(Object)
      type.class.name
    else
      type.to_s
    end
    {:conditions => {:printable_type => value}}
  }


  PRINTABLE_TYPES = [
    ['Заказ', 'Order']
  ]

  def self.available(object, user)
    self.by_printable_type(object).all.to_a.select { |f| f.can_be_used_by?(user)}

  end

  def can_be_used_by?(user)
    self.can_be_accessed_by.include? user.user_type
  end

  def validate_user_types
    if (self.can_be_accessed_by - User::USER_TYPES.map(&:last)).any?
      errors.add(:can_be_accessed_by, 'Некорректный тип ползователя.')
    end

    unless self.can_be_accessed_by.any?
      errors.add(:can_be_accessed_by, 'Выберите хоть один тип пользователя.')
    end

  end

  def before_validation
    tmp_value = self.can_be_accessed_by
    tmp_value ||= []
    self.can_be_accessed_by = tmp_value.map(&:to_i)
  end
end