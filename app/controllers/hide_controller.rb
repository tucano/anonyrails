class HideController < ApplicationController

  def index

    @mylocal  = request.host
    @mylocalport = request.port

    @mytarget = Target.new(params[:myurl],request.query_string,request.method)

    # TRAP RELATIVE CALLS and redirect after url parsing
    if @mytarget.url.relative? then
      newurl = '/http://' + flash[:last_host] + '/' + @mytarget.url.to_s
      redirect_to(newurl) and return
    end
      
    # HANDLE CONNECTION and fetch a response
    begin
      @mytarget.resp = Net::HTTP.start(@mytarget.url.host,@mytarget.url.port) { |http|
        http.send(@mytarget.method, @mytarget.url.path, @mytarget.url.query)  
      }
    rescue SocketError
      render :text => "Socket Error, URL: #{@mytarget.url}"
    rescue Errno::ECONNREFUSED
      render :text => "Connection Refused, URL: #{@mytarget.url}"
    rescue Errno::ECONNRESET
      render :text => "Connection Reset, URL: #{@mytarget.url}"
    rescue NoMethodError
      render :text => "<b/>NoMethodError</b> <br/> URL: #{@mytarget.url} <br/> RESPONSE #{@mytarget.resp} <br/> QUERY_STRING #{@mytarget.url.query} <br/> METHOD #{@mytarget.method}"
    end

    # HANDLE RESPONSE
    case @mytarget.resp
      when Net::HTTPSuccess then 
        @mytarget.parse_body(@mylocal,@mylocalport)
        render :text => @mytarget.body
      when Net::HTTPRedirection then 
        newurl = '/' + CGI::unescape(@mytarget.resp['location'])
        redirect_to(newurl)
      else
        @mytarget.resp.error! unless @mytarget.resp.nil?
    end

    # flash var to store last seen host
    flash[:last_host] = @mytarget.url.host

  end

end
