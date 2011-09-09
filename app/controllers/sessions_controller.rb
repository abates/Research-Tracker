class SessionsController < ActionController::Base
  def create
    auth = request.env["omniauth.auth"]
    #user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:auth] = auth
    logger.info("Created session for #{auth.inspect}")
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    #session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
