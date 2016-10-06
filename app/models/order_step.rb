class OrderStep < ActiveRecord::Base
	belongs_to :order
	belongs_to :user

	# в ожидании
	STATUS_WAITING = 0
	# просмотрен
	STATUS_VIEWED = 1
	# отправлен
	STATUS_FORWARDED = 4

	STATUSES = [['в ожидании', STATUS_WAITING],
							['просмотрен', STATUS_VIEWED],
							['отправлен', STATUS_FORWARDED]]

	
end
