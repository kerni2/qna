class LinksController < ApplicationController
  def destroy
    authorize! :destroy, Question
    question = Question.find(params[:question_id])
    link = Link.find(params[:id])
    link.destroy
    redirect_to question
  end
end
