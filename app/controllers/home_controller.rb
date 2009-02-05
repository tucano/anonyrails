class HomeController < ApplicationController
  def index
    @host            = request.host 
    @host_port       = request.port
    @host_remote     = request.remote_addr
    @host_remoteip   = request.remote_ip
    @host_enviroment = request.env
  end
end
