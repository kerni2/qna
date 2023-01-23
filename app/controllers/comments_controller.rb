class CommentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    publish_comment unless @comment.errors.any?
  end

  private

  def publish_comment
    html = ApplicationController.render(
      partial: 'comments/comment',
      locals: { comment: @comment }
    )

    ActionCable.server.broadcast(
      "comments_question_#{params[:id]}",
      { html: html,
        author_id: @comment.user_id,
        commentable: "#{@commentable.class.name.underscore}-#{@commentable.id}" }
    )
  end

  def commentable
    models = [Question, Answer]
    commentable_class = models.find { |klass| params["#{klass.name.underscore}_id"]}
    @commentable = commentable_class.find(params["#{commentable_class.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
