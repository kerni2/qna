module ControllerHelpers
  def login(user)
    user.confirm
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end
