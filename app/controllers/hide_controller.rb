class HideController < ApplicationController
  def index
    
    # Not sure if this is thebest solution, may be:
    # @mylocal = request.remote_addr
    @mylocal = request.env['HTTP_HOST']
    @method = request.request_method
    @myparams = request.parameters

    @myurl  = URI.parse(request.parameters[:myurl])
    if @myurl.path = "" then @myurl.path= '/index.html' end

    @myresponse = get_net_object()
    
    render :text => @myresponse.body
  
  end

  private

  def get_net_object
    begin
      myresp = Net::HTTP.start(@myurl.host,@myurl.port) { |x|
        x.send(@method, @myurl.path, @myparams)  
      }
    end
  end

end
