module WordpressUtils
  extend ActiveSupport::Concern
  include ApiUtils
  require 'json'

  PER_PAGE = Rails.application.secrets.wp_results_per_page ||= 8
  TAGS="tags"
  RECIPES = "recipes"


  def get_total_posts(response)
    response.header["x-wp-total"].to_i unless response.header["x-wp-total"].blank?
  end

  def get_total_pages(response)
    response.header["x-wp-totalpages"].to_i unless response.header["x-wp-totalpages"].blank?
  end

  def is_embedded_content?(post)
    begin
      embedded_content_slug = get_cached_api_response("embedded_content_slug_replies", format_uri("categories/?_embed&slug=embedded-content")).body
      parsed_slug = JSON.parse(embedded_content_slug)
      slug_id = parsed_slug[0]["id"]
      return post["categories"].include? slug_id
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def get_tag_by_slug(slug)
    results = get_cached_api_response("#{slug}_tag_replies", format_uri("tags?slug="+slug)).body
  end

  def get_all_categories_or_tags_as_json(categories_or_tags, excluded_slug=nil)
    begin

      case categories_or_tags
      when :categories
        query = "categories/?_embed"
      when :tags
        query = "tags/?_embed"
      end

      query += (excluded_slug ? "&exclude=#{excluded_slug}" : "")
      results = get_cached_api_response("#{categories_or_tags}_replies", format_uri(query))
      return JSON.parse results.body
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def get_category_slug_id_by_name(name)
    begin
      slug_response = get_cached_api_response("#{name}_category_slug_replies", format_uri("categories?slug=#{name}"))
      slug_json = JSON.parse slug_response.body
      slug_id = slug_json[0]["id"]
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def get_posts_by_tag(per_page=PER_PAGE, tag=nil, page=nil, excluded_slug_id=nil)
    begin

      if(tag)
        tag_slug = get_cached_api_response("#{tag}_tag_slug_replies", format_uri("tags?slug="+tag))
        parsed_tag_slug = JSON.parse tag_slug.body
        tag_slug_id = parsed_tag_slug[0]["id"]
        uri = format_uri("posts/?_embed&per_page=#{per_page}&page=#{page}&tags=#{tag_slug_id}")
      else
        uri = format_uri("posts/?_embed&per_page=#{per_page}&page=#{page}&categories=#{get_category_slug_id_by_name(RECIPES)}")
      end

      response = get_cached_api_response("#{tag}_page_#{page}_per_page_#{per_page}_exlude_slug_id_#{excluded_slug_id}_posts_replies", uri)
      return response

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def get_posts_by_category(per_page=PER_PAGE, category=nil, page=1, excluded_slug_id=nil)
    begin
      if(category)
        category_slug = get_cached_api_response("#{category}_category_slug_replies", format_uri("categories?slug="+category))
        parsed_category_slug = JSON.parse category_slug.body
        category_slug_id = parsed_category_slug[0]["id"]
        uri = format_uri("posts/?_embed&per_page=#{per_page}&page=#{page}&categories=#{category_slug_id}&categories_exclude=#{excluded_slug_id}")
      else
        uri = format_uri("posts/?_embed&per_page=#{per_page}&page=#{page}&categories_exclude=#{excluded_slug_id}")
      end
      response = get_cached_api_response("#{category}_page_#{page}_per_page_#{per_page}_exlude_slug_id_#{excluded_slug_id}_posts_replies", uri)
      return response
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def get_post_by_name_as_json(name)
    begin
      return JSON.parse get_cached_api_response("#{name.parameterize}_post_replies", format_uri("posts?_embed&slug=#{name}")).body
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def get_post_by_id_as_json(id)
    begin
      return JSON.parse get_cached_api_response("#{id}_post_replies", format_uri("posts/#{id}?_embed")).body
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end


  #controller helpers
  def get_post_details
    @embedded_content = is_embedded_content?(@post)
    @featured_image = get_media_url(@post, :full, true)
    @excerpt = @post['excerpt']['rendered']
    @title = @post['title']['rendered']
    @author = @post['_embedded']['author'][0]['name']
    @content = @post['content']['rendered']
  end


  private
  
  def format_uri(query)
    return URI.parse(Rails.application.secrets.blog_feed_url + query)
  end

end