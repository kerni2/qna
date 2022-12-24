class AttachmentsController < ApplicationController

  def destroy
    question = Question.find(params[:question_id])
    file = ActiveStorage::Attachment.find(params[:id])
    file.purge
    redirect_to question
  end
end
