class AddReplyToToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :reply_to, :integer
  end
end
