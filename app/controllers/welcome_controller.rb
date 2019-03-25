class WelcomeController < ApplicationController

  caches_page :index

  def index
    #TODO: fallback if blog server is down
    begin

      #TODO: MOVE TO DATABASE
      add_notification :popup, t("welcome.stretch_snap_dollars_title"), t("welcome.stretch_snap_dollars_body"), 30000, "/blog?category=save-money"

      recipes_slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug=recipes"))
      parsed_slug = JSON.parse(recipes_slug)
      recipes_slug_id = parsed_slug[0]["id"]

      #blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&pe_page=3&categories_exclude=#{recipes_slug_id}"))

      #move to wordpress_utils.rb
      uri = URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&pe_page=3&categories_exclude=#{recipes_slug_id}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 30 # in seconds
      http.read_timeout = 30 # in seconds
      blogs = http.request(Net::HTTP::Get.new(uri.request_uri)).body
      @blogs = JSON.parse blogs


      #categories = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories/?_embed&exclude=#{recipes_slug_id}"))

      uri = URI(Rails.application.secrets.blog_feed_url + "categories/?_embed&exclude=#{recipes_slug_id}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 30 # in seconds
      http.read_timeout = 30 # in seconds
      categories = http.request(Net::HTTP::Get.new(uri.request_uri)).body
      @categories = JSON.parse categories



      #recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=3&categories=#{recipes_slug_id}"))

      uri = URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=3&categories=#{recipes_slug_id}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 30 # in seconds
      http.read_timeout = 30 # in seconds
      recipes = http.request(Net::HTTP::Get.new(uri.request_uri)).body
      @recipes = JSON.parse recipes


      #tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags"))

      uri = URI(Rails.application.secrets.blog_feed_url + "tags")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 30 # in seconds
      http.read_timeout = 30 # in seconds
      tags = http.request(Net::HTTP::Get.new(uri.request_uri)).body

      @tags = JSON.parse tags


    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

    begin
      #TODO: DRY ME!
      #get videos
      playlist_id = Rails.application.secrets.youtube_default_channel
      playlist_items_url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=#{playlist_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      playlists_url = "https://www.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=#{Rails.application.secrets.youtube_channel_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      playlist_items = Net::HTTP.get(URI(playlist_items_url))
      @videos = JSON.parse playlist_items
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

  end

end
