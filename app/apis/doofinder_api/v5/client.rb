require 'faraday'

module DoofinderAPI
  module V5
    class Client
      include HttpStatusCodes
      include ApiExceptions

      # Search
      API_ENDPOINT = "https://#{Rails.configuration.x.doofinder.search_zone}-search.doofinder.com"

      def search(api_key, hashid, query, query_name, type, filter, page, rpp, sort)
        @token = api_key
        filter_query = (filter.blank? ? '' : '&' + filter.to_query)
        sort_query = (sort.blank? ? '' : '&' + sort.to_query)

        endpoint = "/5/search?hashid=#{hashid}&query=#{query}&query_name=#{query_name}&type=#{type}&page=#{page}&rpp=#{rpp}#{filter_query}#{sort_query}"
        
        response = request(
          client_search,
          http_method: :get,
          endpoint: endpoint
        )
      end

      private

      def client_search
        @_client_search ||= Faraday.new(url: API_ENDPOINT, headers: headers) do |client_search|
          client_search.request :url_encoded
          client_search.adapter Faraday.default_adapter
        end
      end

      def headers
        {  Authorization: @token }
      end

      # request as url_encoded
      def request(client, http_method:, endpoint:, params: {})
        response = client.public_send(http_method, endpoint, params)
        parsed_response = Oj.load(response.body)

        return parsed_response if response_successful?(response)

        raise error_class(response, "Code: #{response.status}, request: #{params} response: #{response.body}")
      end

      def error_class(response, message)
        case response.status
        when HTTP_BAD_REQUEST_CODE
          BadRequestError.new(message)
        when HTTP_UNAUTHORIZED_CODE
          UnauthorizedError.new(message)
        when HTTP_FORBIDDEN_CODE
          ForbiddenError.new(message)
        when HTTP_NOT_FOUND_CODE
          NotFoundError.new(message)
        when HTTP_UNPROCESSABLE_ENTITY_CODE
          UnprocessableEntityError.new(message)
        else
          ApiError.new(message)
        end
      end

      def response_successful?(response)
        response.status == HTTP_OK_CODE
      end

    end
  end
end
