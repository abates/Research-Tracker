require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :google, 'www.omeganetserv.com', 'XHLMh0SFQ8TwSTxo5FRWP9-6' ''
  provider :google_apps, OpenID::Store::Filesystem.new('tmp'), :domain => 'omeganetserv.com'
end

