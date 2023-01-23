class RegistrationsController < Devise::RegistrationsController

  protected

  def build_resource(*args)
    super
    if session["devise.oauth"]
      @user.create_authorization(session["devise.oauth"])
    end
  end
end
