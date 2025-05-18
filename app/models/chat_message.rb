class ChatMessage < ApplicationRecord
  belongs_to :user

  after_create_commit do
    broadcast_append_to "chat_index", partial: "chat/chat_message", target: "messages"
  end
end
