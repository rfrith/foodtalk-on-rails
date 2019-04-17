module ApiUtils
  extend ActiveSupport::Concern

  require 'net/http'
  require 'api_cache'
  require 'dalli'

  API_CACHING_ENABLED = Rails.application.secrets.api_caching_enabled ||= false

  def get_cached_api_response(key, uri)

    if(API_CACHING_ENABLED)
      begin
        APICache.get(key, :cache => 3600) do
          get_api_response(uri)
        end
      rescue Exception => e
        logger.error "An error occurred: #{e.inspect}"
      end
    else
      get_api_response(uri)
    end

  end

  private

  def get_api_response(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 30 # in seconds
    http.read_timeout = 30 # in seconds
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    case response
    when Net::HTTPSuccess
      # 2xx response code
      response
    else
      raise APICache::InvalidResponse
    end
  end

end