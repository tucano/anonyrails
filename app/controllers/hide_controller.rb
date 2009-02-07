class HideController < ApplicationController

  def index

    @mylocal  = request.host
    @mylocalport = request.port
    @mymethod = request.request_method
    @myparams = request.query_string

    target = params[:myurl] 
    if @myparams != "" then
      target = target + '?' + @myparams
    end

    @myurl  = parse_url(target)
    
    if @myurl.absolute? == false then

      newurl = '/http://' + flash[:last_host] + '/' + @myurl.to_s
      redirect_to(newurl)
    
    else
      
      # HANDLE CONNECTION and fetch a response
      # Here NoMethodError is:
      # 1. parameters errors
            
      begin
        @myresp = Net::HTTP.start(@myurl.host,@myurl.port) { |http|
          http.send(@mymethod, @myurl.path, @myurl.query)  
        }
      rescue SocketError
        render :text => "Socket Error, URL: #{@myurl}"
      rescue Errno::ECONNREFUSED
        render :text => "Connection Refused, URL: #{@myurl}"
      rescue Errno::ECONNRESET
        render :text => "Connection Reset, URL: #{@myurl}"
      rescue NoMethodError
        render :text => "<b/>NoMethodError</b> <br/> URL: #{@myurl} <br/> RESPONSE #{@myresp} <br/> QUERY_STRING #{@myurl.query} <br/> METHOD #{@mymethod}"
      end

      # HANDLE RESPONSE
      case @myresp
        when Net::HTTPSuccess then 
          body = parse_links(@myresp.body)
          render :text => body
        when Net::HTTPRedirection then 
          newurl = '/' + CGI::unescape(@myresp['location'])
          redirect_to(newurl)
        else
          @myresp.error! unless @myresp.nil?
      end

      flash[:last_host] = @myurl.host

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

  def parse_links(body)

    # add a basetag
    basetag = '<base href="http://' + @mylocal + ':' + @mylocalport.to_s + '/http://' + @myurl.host + '/"/></head>'
    body.gsub!(/<\/head>/i, basetag)

    
    # change all links in the page
    body.gsub!(/(src=|href=)["'](.*?)["']/) { |x|

      # try to parse as URL
      begin
        oldurl = URI.parse($2)
      rescue URI::InvalidURIError
        oldurl = $2
      end
    
      case oldurl
        when URI then
          if oldurl.absolute? then newurl = $1 + "\"" + "http://" + @mylocal + ':' + @mylocalport.to_s + "/" + $2 + "\""
          else newurl = $1 + "\"" + "http://" + @mylocal + ':' + @mylocalport.to_s + "/http://" + @myurl.host + "/" + $2 + "\""
          end
      end
    }

    return body

  end

end
