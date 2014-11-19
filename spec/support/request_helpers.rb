module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeadersHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.marketplace.v#{version}"
      # request.headers['Accept'] = "application/vnd.marketplace.v1, #{Mime::JSON}"
    end

    def api_response_format(format = Mime::JSON)
      # request.headers['Accpet'] = "#{request.headers['Accept']}, #{format}"
      request.headers['Accept'] = "#{api_header}, #{Mime::JSON}"
      request.headers['Content-Type'] = format.to_s
    end

    def api_authorization_header(token)
      request.headers['Authorization'] =  token
    end

    def include_default_accept_headers
      api_header
      api_response_format
    end
  end
end