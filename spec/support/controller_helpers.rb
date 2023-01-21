module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user.confirm
    sign_in(user)
  end
end
