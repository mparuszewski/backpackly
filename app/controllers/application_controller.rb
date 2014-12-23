class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from Errors::BackpacklyError do |error|
    render json: error, status: error.code
  end
end
