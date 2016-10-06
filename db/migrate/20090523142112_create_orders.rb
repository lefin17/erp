class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
			t.column :user_id, :integer, :null => false					# client id

			# статус
			t.column :status, :integer, :default => Order::STATUS_NEW, :null => false

			# дата сдачи
			t.column :deadline, :datetime

			# вид продукции
			t.column :product_type_id, :integer

			# печатаю сам или не сам
			t.column :is_mysqlf_print_method, :boolean
			# способ печати
			t.column :print_method_id, :integer
			# если не сам -- id контрагента
			t.column :contractor_id, :integer

			# формат, ширина
			t.column :format_w, :integer
			# формат, высота
			t.column :format_h, :integer

			# тираж
			t.column :circulation, :integer

			# цветность
			t.column :colors, :string		# 4+1,4+4, etc.
			# материал
			t.column :material_id, :integer
			# плотность материала
			t.column :material_density, :float

			# постпечать

			# ламинация
			t.column :pp_lamination, :boolean
			t.column :pp_lamination_tag, :string
			# резка
			t.column :pp_cutting, :boolean
			# склейка
			t.column :pp_gumming, :boolean
			# сборка
			t.column :pp_composition, :boolean
			# фольгирование
			t.column :pp_foiling, :boolean
			# пружина
			t.column :pp_spring, :boolean
			# переплёт
			t.column :pp_twining, :boolean
			# фальцовка
			t.column :pp_falze, :boolean
			t.column :pp_falze_tag, :string
			# биговка
			t.column :pp_bigging, :boolean
			t.column :pp_bigging_tag, :string
			# скругление углов
			t.column :pp_rounding, :boolean

			# дизайн
			t.column :design_tasks, :string
			# дата сдачи работ дизайнером
			t.column :design_deadline, :datetime

			# обработка
			t.column :processing, :text

			# доставка?
			t.column :is_delivering, :boolean
			# адрес доставки
			t.column :delivery_to, :string

			# цветопроба
			t.column :is_colorprobe, :boolean

			# комментарий
			t.column :comment, :text

			# флаг платежа
			t.column :payment_flag, :integer, :default => Order::PAYMENT_FLAG_NOT_PAYED, :null => false
			# оплатить до
			t.column :pay_till, :datetime
			# цена
			t.column :price, :float, :default => 0
			# номер счёта
			t.column :bill_no, :string
			# дата счёта
			t.column :bill_date, :datetime

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
