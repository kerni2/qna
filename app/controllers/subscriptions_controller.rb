class SubscriptionsController < ApplicationController
  before_action :find_question
  authorize_resource

  def create
    subscription = Subscription.new(question_id: @question.id, user_id: current_user.id)

    if subscription.save
      redirect_to @question, notice: "You successfuly subscribed!"
    else
      redirect_to @question, alert: "Something went wrong. Subscription doesn't save."
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    redirect_to @question, notice: "You are unsubscribed from this question."
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
