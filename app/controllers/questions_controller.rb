class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
    @best_answer = @question.best_answer
    @answers = @question.answers.where.not(id: @question.best_answer_id)
    @question.links.new
    @question_comment = @question.comments.new
    @answer_comment = @answer.comments.new

    if current_user
      @subscription = Subscription.find_by(question_id: @question.id, user_id: current_user.id)
    end

    gon.question_id = @question.id
    gon.answer_comment = @answer_comment
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
    publish_question unless @question.errors.any?
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

  def publish_question
    ActionCable.server.broadcast('questions_channel',
      ApplicationController.render(partial: 'questions/question',
                                   locals: { question: @question })
    )
  end
end
