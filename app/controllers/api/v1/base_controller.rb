class Api::V1::BaseController < ActionController::Base
  before_action :doorkeeper_authorize!

  rescue_from CanCan::AccessDenied do |exeption|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'application/json' }
    end
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token['resource_owner_id']) if doorkeeper_token
  end

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end
end
