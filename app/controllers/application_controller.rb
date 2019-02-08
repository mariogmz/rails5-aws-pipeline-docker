class ApplicationController < ActionController::API
  def hello
    render json: {message: 'Hello World 2.0'}
  end
end
