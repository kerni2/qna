class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:id]}"
  end
end
