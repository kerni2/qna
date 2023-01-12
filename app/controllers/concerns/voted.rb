module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_resource, only: [:like, :unlike]
    before_action :find_vote, only: [:like, :unlike]
  end

  def like
    vote_calculation(1)
  end

  def unlike
    vote_calculation(-1)
  end

  private

  def vote_calculation(rating)
    if @vote.present?
      @vote.rating == rating ? @vote.destroy : @vote.update(rating: rating)
    else
      current_user.votes.create(votable_type: "#{@resource.class}", votable_id: @resource.id, rating: rating)
    end

    respond_to do |format|
      format.json { render json: @resource.rating }
    end
  end

  def find_vote
    @vote = Vote.find_by(votable_type: "#{@resource.class}",
                         votable_id: @resource.id,
                         user_id: current_user.id)
  end

  def find_resource
    model = controller_name.classify.constantize
    @resource = model.find(params[:id])
  end

end
