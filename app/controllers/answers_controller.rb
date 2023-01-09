class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :find_question, only: [:create, :edit]
  before_action :find_answer, only: [:edit, :update, :destroy, :mark_as_best]

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def mark_as_best
    question = @answer.question
    question.update(best_answer_id: @answer.id)
    question.reward.update(user_id: @answer.user_id) if question.reward.present?
    redirect_to question
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                   links_attributes: [:id, :name, :url, :_destroy])
  end
end
