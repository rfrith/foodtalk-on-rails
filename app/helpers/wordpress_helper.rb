module WordpressHelper

  def get_media_url(post, size, *degrade)
    begin
      if(!post["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"].empty?)
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

      else
        media_url = post["_embedded"]["wp:featuredmedia"][0]["source_url"]
      end

    rescue
      # do nothing
    end
  end

  def filter_content_for_display(content)
    content.gsub!('alignright', 'float-right')
    content.gsub!('alignleft', 'float-left')
    content.gsub!('aligncenter', 'mx-auto d-block')
    return content
  end

  def filter_categories_or_tags_for_display!(categories_or_tags)
    categories_or_tags.delete_if { |c| c["slug"] == "uncategorized" || c["slug"] == "embedded-content" }
  end

  def should_show_post_featured_image
    @featured_image && !@embedded_content
  end

  def should_show_post_title
    !@embedded_content
  end

end