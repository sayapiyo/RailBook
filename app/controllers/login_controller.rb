class LoginController < ApplicationController
  def auth
    usr = User.authenticate(params[:username], params[:password])
    if usr then
      reset_session
      session[:usr] = usr.id
      redirect_to params[:referer]
    else
      flash.now[:referer] = params[:referer]
      @error = 'username/passwordが間違っています'
      render 'index'
    end
  end

  def logout
    reset_session
    redirect_to '/'
  end
end
