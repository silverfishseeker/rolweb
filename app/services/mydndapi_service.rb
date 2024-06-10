require 'net/http'

class MydndapiService
    def initialize
        @base_url = "http://api:3000/"
    end

    def get (url)
        Rails.logger.info url
        HTTParty.get(@base_url + url).parsed_response
    end

    def post(url, params)
        # @param params debde de ser un mapa
        uri = URI(@base_url + '/' + url)
        Net::HTTP.post_form(uri, *params)
    end

    def patch(url, params)
        # @param params debde de ser un mapa
        uri = URI(@base_url + '/' + url)
        Net::HTTP.patch(uri, *params)
    end

    def delete(url)
        Net::HTTP.delete URI(@base_url + '/' + url)
    end




end