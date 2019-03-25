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

      blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&pe_page=3&categories_exclude=#{recipes_slug_id}"))
      @blogs = JSON.parse blogs

      categories = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories/?_embed&exclude=#{recipes_slug_id}"))
      @categories = JSON.parse categories

      recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=3&categories=#{recipes_slug_id}"))
      tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags"))

      @tags = JSON.parse tags
      @recipes = JSON.parse recipes

    rescue
      #do nothing
    end

    begin
      #TODO: DRY ME!
      #get videos
      playlist_id = Rails.application.secrets.youtube_default_channel
      playlist_items_url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=#{playlist_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      playlists_url = "https://www.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=#{Rails.application.secrets.youtube_channel_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      playlist_items = Net::HTTP.get(URI(playlist_items_url))
      @videos = JSON.parse playlist_items
    rescue
      #do nothing
    end

  end

end
