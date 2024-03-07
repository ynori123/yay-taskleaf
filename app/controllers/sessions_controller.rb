class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def index
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: "ログインしました。"
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "ログアウトしました。"
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
