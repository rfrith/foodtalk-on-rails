class WelcomeController < ApplicationController

  def index
    #TODO: fallback if blog server is down

    blogs = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=5"))
    categories = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories"))

    @categories = JSON.parse categories
    @blogs = JSON.parse blogs

    #remove "recipes" from categories and blogs as they are displayed on a different page
    recipes_category = nil
    @categories.delete_if do |c|
      if c["slug"] == "recipes"
        recipes_category = c["id"]
        true
      end
    end
    @blogs.delete_if do |b|
      delete_me = false
      b["categories"].each do |c|
        if(c == recipes_category)
          delete_me = true
        end
      end
      delete_me
    end

    slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug=recipes"))
    parsed_slug = JSON.parse(slug)
    slug_id = parsed_slug[0]["id"]
    recipes = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=3&categories=#{slug_id}"))
    tags = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags"))

    @tags = JSON.parse tags
    @recipes = JSON.parse recipes

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
