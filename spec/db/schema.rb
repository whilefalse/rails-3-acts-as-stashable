ActiveRecord::Schema.define do
  create_table "posts", :force => true do |t|
    t.column "title", :text
  end
end
