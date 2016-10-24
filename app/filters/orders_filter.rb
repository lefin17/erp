class OrdersFilter < Struct.new(:from, :to, :manager_id, :status, :client_id, :soc, :sod, :period)

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
   
   self[:period] = "month" if period.to_s == ''

   if period.present?
      if period.to_sym != :custom
        self[:from], self[:to] = self.class.range_by_period(period)
      end

      unless from.blank?
        scope = scope.later_than(from)
      end

      unless to.blank?
        scope = scope.earlier_than(to)
      end
    end

    if manager_id > 0
      scope = scope.by_manager(manager_id)
    end

    unless status.blank?
      scope = scope.with_status(status)
    end

    if client_id > 0
      scope = scope.by_client(client_id)
    end
    scope = scope.scoped({:joins => [:order_steps, :product_type], :group => "orders.id"})
    scope.ordered_by order_column, order_direction
  end

  def order_column
    soc.blank? ? 'orders.updated_at' : soc
  end

  def order_direction
    sod.blank? ? 'DESC' : sod
  end

  def client_id
    self[:client_id].to_i
  end

  def manager_id
    self[:manager_id].to_i
  end

  def custom_period?
    !self[:period].blank? && self[:period].to_sym == :custom
  end

  def self.range_by_period(period)
    case period.to_sym
      when :yesterday
        [Date.yesterday.beginning_of_day, Date.yesterday.end_of_day]
      when :today
        [Date.today.beginning_of_day, Date.today.end_of_day]
      when :tomorrow
        [Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day]
      when :week
        [Date.today.beginning_of_week, Date.today.end_of_week]
      when :month
        [Date.today.beginning_of_month, Date.today.end_of_month]
      when :prevmonth
        [Date.today.beginning_of_month.advance(:months => -1), Date.today.end_of_month.advance(:months => -1, :days => -1)]
      when :prevmonth2
        [Date.today.beginning_of_month.advance(:months => -2), Date.today.end_of_month.advance(:months => -2, :days => -1)]
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
