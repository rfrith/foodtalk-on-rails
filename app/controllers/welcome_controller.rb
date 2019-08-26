class WelcomeController < ApplicationController

  include WordpressUtils, WordpressHelper, YoutubeUtils


  def index

    if !policy(:site_access).view_default_index?



      redirect_to "/#{I18n.locale}/#{request.subdomain}", locale: I18n.locale

    else

      begin

        #TODO: left here as an example for putting a pop-up on the homepage
        #add_notification :popup, t("welcome.stretch_snap_dollars_title"), t("welcome.stretch_snap_dollars_body"), 30000, "/blog?slug=save-money"

        blogs = get_posts_by_category(3, nil, 1, get_category_slug_id_by_name(RECIPES))
        @blogs = JSON.parse blogs.body

        @tags = get_all_categories_or_tags_as_json(:tags)

        @categories = filter_categories_or_tags_for_display! get_all_categories_or_tags_as_json(:categories, get_category_slug_id_by_name(RECIPES))

        recipes = get_posts_by_tag(3, nil, 1, nil)
        @recipes = JSON.parse recipes.body
      rescue Exception => e
        logger.error "An error occurred: #{e.inspect}"
      end

      begin
        #get recent videos - TODO: make maxResults & order ENV vars
        playlist_id = get_playlist_id({})
        @videos ||= get_playlist_items("yt_recent_videos_replies", playlist_id, 3)
      rescue Exception => e
        logger.error "An error occurred: #{e.inspect}"
      end

    end





  end

end