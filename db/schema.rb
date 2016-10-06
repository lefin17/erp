# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120118075731) do

  create_table "companyactions", :force => true do |t|
    t.string   "aname"
    t.boolean  "isdefault",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contactorproducttypes", :force => true do |t|
    t.integer  "contractor_id"
    t.integer  "product_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contractorprintmethods", :force => true do |t|
    t.integer  "contractor_id"
    t.integer  "print_method_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contractors", :force => true do |t|
    t.string   "name",                     :limit => 32
    t.string   "email",                    :limit => 32
    t.string   "phone",                    :limit => 32
    t.string   "jur_name"
    t.string   "jur_address"
    t.string   "jur_inn"
    t.string   "jur_kpp"
    t.string   "jur_account"
    t.string   "jur_bank"
    t.string   "jur_bik"
    t.string   "jur_korr_account"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notes",                    :limit => 250
    t.integer  "contractorprintmethod_id"
    t.integer  "contactorproducttype_id"
  end

  create_table "contracttypes", :force => true do |t|
    t.string   "aname"
    t.boolean  "isdefault",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "deliveries", :force => true do |t|
    t.integer  "order_id"
    t.text     "address"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dumps", :force => true do |t|
    t.integer  "user_id"
    t.text     "tables"
    t.string   "status",     :default => "new"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "order_id"
    t.string   "number"
    t.date     "date"
    t.string   "state"
    t.string   "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materials", :force => true do |t|
    t.string   "name"
    t.float    "density",    :default => 0.0
    t.integer  "w"
    t.integer  "h"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",    :default => true
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_steps", :force => true do |t|
    t.integer  "order_id",                       :null => false
    t.integer  "user_id",                        :null => false
    t.text     "comment"
    t.integer  "status",      :default => 0,     :null => false
    t.boolean  "is_deprived", :default => false
    t.integer  "depriver_id"
    t.datetime "viewed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id",                                   :null => false
    t.integer  "status",                 :default => 0,     :null => false
    t.datetime "deadline"
    t.integer  "product_type_id"
    t.boolean  "is_mysqlf_print_method"
    t.integer  "print_method_id"
    t.integer  "contractor_id"
    t.integer  "format_w"
    t.integer  "format_h"
    t.integer  "circulation"
    t.string   "colors"
    t.integer  "material_id"
    t.float    "material_density"
    t.boolean  "pp_lamination"
    t.string   "pp_lamination_tag"
    t.boolean  "pp_cutting"
    t.boolean  "pp_gumming"
    t.boolean  "pp_composition"
    t.boolean  "pp_foiling"
    t.boolean  "pp_spring"
    t.boolean  "pp_twining"
    t.boolean  "pp_falze"
    t.string   "pp_falze_tag"
    t.boolean  "pp_bigging"
    t.string   "pp_bigging_tag"
    t.boolean  "pp_rounding"
    t.string   "design_tasks"
    t.datetime "design_deadline"
    t.text     "processing"
    t.boolean  "is_delivering"
    t.string   "delivery_to"
    t.boolean  "is_colorprobe"
    t.text     "comment"
    t.integer  "payment_flag",           :default => 0,     :null => false
    t.datetime "pay_till"
    t.float    "price",                  :default => 0.0
    t.string   "bill_no"
    t.datetime "bill_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date_order"
    t.string   "user_l_payment"
    t.integer  "code_id",                :default => 16000
    t.float    "payment_received",       :default => 0.0,   :null => false
    t.string   "location"
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id",                                           :null => false
    t.decimal  "summ",                :precision => 10, :scale => 2, :null => false
    t.integer  "payment_source_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "persons", :force => true do |t|
    t.integer  "user_id",                    :default => 0
    t.string   "login",                      :default => "", :null => false
    t.string   "password",     :limit => 32,                 :null => false
    t.string   "fio",                        :default => "", :null => false
    t.string   "email",        :limit => 32
    t.string   "phone",        :limit => 32
    t.string   "phone_mobile", :limit => 32
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_prints", :force => true do |t|
    t.string   "name"
    t.boolean  "has_params", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "print_forms", :force => true do |t|
    t.string "template_name",      :null => false
    t.string "name",               :null => false
    t.string "can_be_accessed_by"
    t.string "printable_type"
  end

  create_table "print_methods", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_post_prints", :force => true do |t|
    t.integer  "product_id"
    t.integer  "post_print_id"
    t.string   "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "product_id"
    t.integer  "product_type_id"
    t.integer  "print_method_id"
    t.integer  "width"
    t.integer  "height"
    t.string   "colors"
    t.integer  "material_id"
    t.float    "material_density"
    t.string   "model"
    t.boolean  "proofing"
    t.integer  "price"
    t.integer  "package_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "client_id",                                   :null => false
    t.integer  "person_id"
    t.integer  "user_id",                                     :null => false
    t.integer  "fromuser_id",                                 :null => false
    t.string   "FIO",           :limit => 250,                :null => false
    t.integer  "relevance",                    :default => 0, :null => false
    t.integer  "taskaction_id",                               :null => false
    t.string   "subject",       :limit => 500,                :null => false
    t.string   "objection",     :limit => 500
    t.integer  "realized",                     :default => 0
    t.string   "result",        :limit => 200
    t.datetime "realized_at",                                 :null => false
    t.integer  "state",                        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userfroms", :force => true do |t|
    t.string   "aname"
    t.boolean  "isdefault",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "user_type",                                             :null => false
    t.string   "login",                          :default => "",        :null => false
    t.string   "password",         :limit => 32,                        :null => false
    t.text     "comment"
    t.string   "name",             :limit => 50
    t.string   "email",            :limit => 32
    t.string   "phone",            :limit => 32
    t.string   "phone_mobile",     :limit => 32
    t.string   "jur_name"
    t.string   "jur_address"
    t.string   "jur_inn"
    t.string   "jur_kpp"
    t.string   "jur_account"
    t.string   "jur_bank"
    t.string   "jur_bik"
    t.string   "jur_korr_account"
    t.boolean  "is_inactive",                    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_site",        :limit => 50
    t.string   "adress_fact"
    t.string   "adress_delivery"
    t.string   "contact_fio"
    t.string   "color",                          :default => "#FFFFFF"
    t.string   "contract",                       :default => "нет"
    t.integer  "owner_id"
    t.integer  "contracttype_id"
    t.integer  "companyaction_id"
    t.integer  "userfrom_id"
  end

end
