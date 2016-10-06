class TasksFilter < Struct.new(:from, :to, :user_id, :period, :type)

  def initialize(*args)
    super(*args)
    if args.first.is_a?(Hash)
      values = HashWithIndifferentAccess.new(args.first)
      members.each do |member|
        self.send("#{member}=", values[member]) if values.has_key?(member)
      end
    end
  end

  def apply(scope)
    if period.present? && period.to_sym != :custom
      self[:from], self[:to] = self.class.range_by_period(period)
    end

    unless from.blank?
      scope = scope.later_than(Date.parse(from))
    end

    unless to.blank?
      scope = scope.earlier_than(Date.parse(to))
    end

    unless user_id.blank?
      scope = scope.by_user(user_id)
    end

    unless type.blank?
      scope = scope.tasktype(type)
    end
    scope
  end

  def user_id
    self[:user_id].to_i
  end

  def type
    self[:type].to_i
  end

  def custom_period?
    self[:period] && self[:period].to_sym == :custom
  end

  def self.range_by_period(period)
    case period.to_sym
      when :yesterday
        [Date.yesterday.beginning_of_day, Date.yesterday.end_of_day]
      when :today
        [Date.beginning_of_day, Date.today.end_of_day]
      when :tomorrow
        [Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day]
      when :week
        [Date.today.beginning_of_week, Date.today.end_of_week]
      when :month
        [Date.today.beginning_of_month, Date.today.end_of_month]
      when :less1
        [nil, Date.today >> 1]
      when :more1month
        [Date.today >> 1, nil]
      when :more2month
        [Date.today >> 2, nil]
      when :more3month
        [Date.today >> 3, nil]
      when :more6month
        [Date.today >> 6, nil]
      when :more9month
        [Date.today >> 9, nil]
      when :more12month
        [Date.today >> 12, nil]
      end
  end
end