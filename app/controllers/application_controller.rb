class ApplicationController < ActionController::API
  def hello
    render json: {message: 'Hello World'}
  end
end
