class PlaylistsController < ApplicationController

  def check_item_belongs_to_playlist
    url = params[:url]
    belongs = @current_user.playlist_items.where(url: url).exists?

    render :json => belongs.to_json
  end

  def add_item_to_playlist
    url = params[:url]
    name = params[:name]
    category = PlaylistItem.categories[params[:category]]
    playlist = @current_user.playlists.where(category: category).first

    if(playlist.nil?)
      category_name = PlaylistItem.categories.key(category).titleize.pluralize
      playlist = Playlist.new(name: category_name, category: category)
      @current_user.playlists << playlist
    end

    item_exists = playlist.playlist_items.where(name: name, url: url, category: category).exists?

    if(playlist.playlist_items.blank? || !item_exists)
      pi = PlaylistItem.new(name: name, url: url, category: category)
      playlist.playlist_items << pi

    #delete if already exists (toggle add/remove)
    elsif(item_exists)
      pi = playlist.playlist_items.where(name: name, url: url, category: category).first
      pi.delete
    end

    respond_to do |format|
      format.js
    end
  end

  def remove_item_from_playlist
    pi = @current_user.playlist_items.find(params[:id])

    if(!pi.blank?)
      pi = @current_user.playlist_items.find(params[:id])
      @playlist_item_id = pi.id #for removal in view
      pi.delete
    end

    respond_to do |format|
      format.js
    end

  end

end