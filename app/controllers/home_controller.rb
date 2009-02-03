class HomeController < ApplicationController
  def index
    @request_vars = request.env
  end
end
