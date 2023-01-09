class LinksController < ApplicationController
  def destroy
    question = Question.find(params[:question_id])
    link = Link.find(params[:id])
    link.destroy
    redirect_to question
  end
end
