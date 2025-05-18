class ChatMessagesController < ApplicationController
  before_action :ensure_that_signed_in, only: %i[create]

  def create
    @chat_message = ChatMessage.new(chat_message_params)

    respond_to do |format|
      if @chat_message.save
        format.turbo_stream {
          target = "messages"
          render turbo_stream: turbo_stream.append(target, partial: "chat/chat_message", locals: { chat_message: @chat_message })
        }
        format.html { redirect_to chat_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat_message.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:content, :user_id)
  end
end
