class Api::V1::QuestionsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token
  before_action -> { authorize! :create, Question }, only: [:index, :show, :create]
  before_action :find_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def create
    question = current_resource_owner.questions.new(question_params)

    if question.save
      render json: question, serializer: QuestionSerializer, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @question
    if @question.destroy
      render json: { status: :ok }
    else
      render json: { errors: "Something went wrong. Question did not delete." }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
