class CreateChatMessage < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_messages do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
