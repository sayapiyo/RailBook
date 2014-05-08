class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :id_invalid

  private
  def id_invalid(e)
    render 'shared/record_not_found', status: 404
  end
end
