class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    html = ApplicationController.render(
      partial: 'comments/comment',
      locals: { comment: @comment }
    )

    ActionCable.server.broadcast(
      'comments_channel',
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
