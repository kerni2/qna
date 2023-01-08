class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @best_answer = @question.best_answer
    @answers = @question.answers.where.not(id: @question.best_answer_id)
    @question.links.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted.'
    else
      flash[:notice] = "You can't delete someone else's question."
      render :show
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url, :id, :_destroy],
                                     reward_attributes: [:title, :image])
  end
end
