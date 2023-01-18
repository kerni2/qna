class CommentsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "comments_channel"
    stream_from "comments_question_#{params[:id]}"
  end
end
