module WordpressHelper

  def get_blog_media_url(blog)
    begin
      if (blog["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"])
        media_url = blog["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"]
      elsif (blog["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["full"])
        media_url = blog["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["full"]["source_url"]
      elsif (blog["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"])
        media_url = blog["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"]
      end
      return media_url
    rescue
      # do nothing
    end
  end

  def get_recipe_media_url(recipe)
    begin
      if (recipe["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"])
        media_url = recipe["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"]
      elsif (blog["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["full"])
        media_url = recipe["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["full"]["source_url"]
      elsif (blog["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"])
        media_url = recipe["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"]
      end
      return media_url
    rescue
      # do nothing
    end
  end

end