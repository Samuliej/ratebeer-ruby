class ChatController < ApplicationController
  before_action :ensure_that_signed_in, only: %i[index]
  def index
    @chat_message = ChatMessage.new
    @chat_messages = ChatMessage.includes(:user).all
  end
end
