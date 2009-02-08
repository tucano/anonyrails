class Target

  attr_reader :url, :method
  attr_accessor :resp, :body

  # resp.body strore the original body, @body store the parsed body

  def initialize(url_str, query_str, method)
    @url = url_parse(append_query(url_str, query_str))
    @method = method
    @body = nil
  end

  def parse_body(local,localport)
    
    # add a basetag
    basetag = '<base href="http://' + local + ':' + localport.to_s + '/http://' + @url.host + '/"/></head>'
    @body.gsub!(/<\/head>/i, basetag)

    # change all links in the page
    @body.gsub!(/(src=|href=)["'](.*?)["']/) { |x|

      # try to parse as URL
      # FIXME here I rescue an error but nothing more 
      begin
        oldurl = URI.parse($2)
      rescue URI::InvalidURIError
        oldurl = $2
      end

      case oldurl
        when URI then
          if oldurl.absolute? then 
            newurl = $1 + "\"" + "http://" + local + ':' + localport.to_s + "/" + $2 + "\""
          else 
            newurl = $1 + "\"" + "http://" + local + ':' + localport.to_s + "/http://" + @url.host + "/" + $2 + "\""
          end
      end
    }

  end

  private

  def url_parse(uri_str)
    url = URI.parse(uri_str)
    if url.path == "" then 
      url.path= '/index.html'
    end
    return url
  end

  def append_query(url_str, query_str)
    case query_str
      when "", nil then return url_str
      else
        return url_str + '?' + query_str
    end
  end

end
