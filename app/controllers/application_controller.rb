class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from Errors::BackpacklyError do |error|
    render json: error, status: error.code
  end

  rescue_from StandardError do
    error = Errors::BackpacklyError.new('make sure your request is correct', 400)
    render json: error, status: error.code
  end
end
