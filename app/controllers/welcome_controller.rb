class WelcomeController < ApplicationController

  require 'api_cache'
  require 'dalli'

  APICache.store = APICache::DalliStore.new(Dalli::Client.new)

  def index
    #TODO: fallback if blog server is down
    begin

      #TODO: MOVE TO DATABASE
      add_notification :popup, t("welcome.stretch_snap_dollars_title"), t("welcome.stretch_snap_dollars_body"), 30000, "/blog?category=save-money"

      recipes_slug = get_cached_api_response('recipes_slug_replies', URI(Rails.application.secrets.blog_feed_url + "categories?slug=recipes"))
      parsed_slug = JSON.parse(recipes_slug)
      recipes_slug_id = parsed_slug[0]["id"]

      @blogs = JSON.parse get_cached_api_response('wp_blog_replies', URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&pe_page=3&categories_exclude=#{recipes_slug_id}"))
      @categories = JSON.parse get_cached_api_response('wp_blog_category_replies', URI(Rails.application.secrets.blog_feed_url + "categories/?_embed&exclude=#{recipes_slug_id}"))
      @recipes = JSON.parse get_cached_api_response('wp_recipes_replies', URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=3&categories=#{recipes_slug_id}"))
      @tags = JSON.parse get_cached_api_response('wp_tags_replies', URI(Rails.application.secrets.blog_feed_url + "tags"))

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

    begin
      #TODO: DRY ME!
      #get videos
      playlist_id = Rails.application.secrets.youtube_default_channel
      playlist_items_url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=#{playlist_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      playlists_url = "https://www.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=#{Rails.application.secrets.youtube_channel_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      @videos = JSON.parse get_cached_api_response('yt_videos_replies', URI(playlist_items_url))

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

  end

  #TODO: move to concern
  def get_cached_api_response(key, uri)
    APICache.get(key, :cache => 3600) do
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 30 # in seconds
      http.read_timeout = 30 # in seconds
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      case response
      when Net::HTTPSuccess
        # 2xx response code
        response.body
      else
        raise APICache::InvalidResponse
      end
    end

  end


end
