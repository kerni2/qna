class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, @rewards
    @rewards = current_user.rewards
  end
end
