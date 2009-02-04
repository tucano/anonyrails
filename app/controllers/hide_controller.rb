# HideController
class HideController < ApplicationController

  def index
    
    @mylocal = request.host
    @myport  = request.port
    @mymethod = request.request_method
    @myparams = request.parameters

    @myurl  = parse_url(request.parameters[:myurl])

    begin
      myresp = Net::HTTP.start(@myurl.host,@myurl.port) { |x|
        x.send(@mymethod, @myurl.path, @myparams)  
      }
    end

    case myresp
      when Net::HTTPSuccess then 
        render :text => myresp.body
      when Net::HTTPRedirection then 
        newurl = '/' + CGI::unescape(myresp['location'])
        redirect_to(newurl)
    else
      myresp.error!
    end
  end

  private

  def parse_url(url_str)
    url = URI.parse(url_str)
    if url.path == "" then 
      url.path= '/index.html'
    end
    return url
  end

end
