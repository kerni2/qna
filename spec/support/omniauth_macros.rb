module OmniauthMacros
  def mock_auth_hash_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'email' => 'somemail@mail.com',
      },
      'credentials' => {
        'token' => 'mock_token'
      }
    })
  end

  def mock_auth_hash_without_email_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123545',
      'info' => {},
      'credentials' => {
        'token' => 'mock_token'
      }
    })
  end

  def mock_auth_hash_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'email' => 'somemail@mail.com',
      },
      'credentials' => {
        'token' => 'mock_token'
      }
    })
  end

  def mock_auth_hash_without_email_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {},
      'credentials' => {
        'token' => 'mock_token'
      }
    })
  end
end
