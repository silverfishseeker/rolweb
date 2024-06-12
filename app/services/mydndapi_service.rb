require 'net/http'

class MydndapiService
    def getUrl(url)
        "http://api:3000/#{url}"
    end

    def get (url, timeout: 60)
        HTTParty.get(getUrl(url), timeout: timeout).parsed_response
    end

    def put(url, params)
        HTTParty.put(getUrl(url), body: params.as_json).parsed_response
    end

    def delete(url)
        HTTParty.delete(getUrl(url)).parsed_response
    end




end