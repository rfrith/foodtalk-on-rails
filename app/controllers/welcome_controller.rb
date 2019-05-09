class WelcomeController < ApplicationController

  include WordpressUtils, WordpressHelper


  def index
    #TODO: fallback if blog server is down
    begin

      recipes_slug = get_cached_api_response('recipes_slug_replies', URI(Rails.application.secrets.blog_feed_url + "categories?slug=recipes")).body
      parsed_slug = JSON.parse(recipes_slug)
      recipes_slug_id = parsed_slug[0]["id"]

      @blogs ||= JSON.parse get_cached_api_response('wp_blog_replies', URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&pe_page=3&categories_exclude=#{recipes_slug_id}")).body
      @categories ||= JSON.parse get_cached_api_response('wp_blog_category_replies', URI(Rails.application.secrets.blog_feed_url + "categories/?_embed&exclude=#{recipes_slug_id}")).body
      @recipes ||= JSON.parse get_cached_api_response('wp_recipes_replies', URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=3&categories=#{recipes_slug_id}")).body
      @tags ||= JSON.parse get_cached_api_response('wp_tags_replies', URI(Rails.application.secrets.blog_feed_url + "tags")).body

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

    begin
      #TODO: DRY ME!
      #get videos
      playlist_id = Rails.application.secrets.youtube_default_channel
      playlist_items_url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=#{playlist_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      playlists_url = "https://www.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=#{Rails.application.secrets.youtube_channel_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      @videos ||= JSON.parse get_cached_api_response('yt_videos_replies', URI(playlist_items_url)).body

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

  end

end