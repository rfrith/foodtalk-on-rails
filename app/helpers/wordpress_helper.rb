module WordpressHelper

  def get_media_url(post, size, *degrade)
    begin
      if (degrade)
        case size
        when :thumbnail
          #can't degrade
          media_url = post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"]

        when :medium
          if (post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"])
            media_url = post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"]
          elsif (post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"])
            media_url = post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"]
          end

        when :full
          if (post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["full"])
            media_url = post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["full"]["source_url"]
          elsif (post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"])
            media_url = post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["medium"]["source_url"]
          elsif (post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"])
            media_url = post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"]
          end
        end
      else
        media_url = post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["#{size}"]["source_url"]
      end
    rescue
      # do nothing
    end
  end

end