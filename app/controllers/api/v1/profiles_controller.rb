class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :read, :profile
    render json: current_resource_owner, serializer: UserSerializer
  end

  def index
    authorize! :read, :profiles
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users, each_serializer: UserSerializer
  end
end
