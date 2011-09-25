class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :authorize

  def index
    @projects = Project.all
  end

  private
    def current_user
      # make a deep copy so that the original auth data cannot be overwritten
      Marshal.load(Marshal.dump(session[:auth]))
    end

    def authorize
      if (session[:auth].nil?)
        redirect_to '/thesis/auth/google_apps'
      else
        unless (USERS[session[:auth]['uid']] == session[:auth]['user_info']['email'])
          redirect_to 'http://www.google.com'
          return
        end
      end
    end

    def redirect_back
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to root_path
      end
    end
end
