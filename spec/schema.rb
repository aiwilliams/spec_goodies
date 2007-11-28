ActiveRecord::Schema.define do
  create_table "people", :force => true do |t|
    t.column "first_name", :string
    t.column "last_name", :string
  end
end
  