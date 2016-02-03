def set_omniauth(credentials, opts = {})
  credentials = credentials.merge(opts)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = OmniAuth::AuthHash.new(credentials)
end


def set_invalid_omniauth(opts = {})
  credentials = { :provider => :twitter,
                  :invalid  => :invalid_crendentials
                 }.merge(opts)

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
end
