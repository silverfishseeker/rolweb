require 'net/http'

class MydndapiService
    def getUrl(url)
        "http://api:3000/#{url}"
    end

    def get (url, timeout: 60)
        check_response HTTParty.get(getUrl(url), timeout: timeout)
    end

    def put(url, params)
        check_response HTTParty.put(getUrl(url), body: params.as_json)
    end

    def delete(url)
        check_response HTTParty.delete(getUrl(url))
    end

    private

    def check_response(response)
        parsed = response.parsed_response
        unless response.code == 204 or parsed.is_a?(Hash) or parsed.is_a?(Array)
            raise "MydndapiService#check_response: Unexpected response, code:{#{response.code}} content:{#{parsed}}" # corta para no saturar logs
        end
        parsed
    end

end