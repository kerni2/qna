class OauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_action :verify_authenticity_token

  def github
    authorize_user(request.env['omniauth.auth'])
  end

  def facebook
    authorize_user(request.env['omniauth.auth'])
  end

  private

  def authorize_user(auth)
    @user = User.find_for_oauth(auth)

    if @user&.persisted? && @user.confirmed?
      sign_in_and_redirect @user, event: :authintication
      set_flash_message(:notice, :success, kind: params[:action].capitalize) if is_navigational_format?
    elsif @user&.persisted? && !@user.confirmed?
      redirect_to new_user_session_path, alert: "Please confirm your registered email to access your account."
    else
      session["devise.oauth"] = auth.except(:extra)
      redirect_to new_user_registration_url,
        notice: "You need to register once. Than you can enter with #{auth['provider'].capitalize}."
    end
  end
end
