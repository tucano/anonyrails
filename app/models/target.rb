class Target

  attr_accessor :url

  def initialize(url_str, query_str)
    @url = url_parse(append_query(url_str, query_str))
  end

  private

  def url_parse(uri_str)
    url = URI.parse(uri_str)
    if url.path == "" then 
      url.path= '/index.html'
    end
  end

  def append_query(url_str, query_str)
    case query_str
      when "", nil then return url_str
      else
        return url_str + '?' + query_str
    end
  end

end
