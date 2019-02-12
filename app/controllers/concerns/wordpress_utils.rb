module WordpressUtils
  extend ActiveSupport::Concern

  require 'net/http'
  require 'json'

  PER_PAGE = 8
  TAGS="tags"
  RECIPES = "recipes"

  def is_embedded_content?(post)
    slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url+"categories/?_embed&slug=embedded-content"))
    parsed_slug = JSON.parse(slug)
    slug_id = parsed_slug[0]["id"]
    return post["categories"].include? slug_id
  end

  def get_tag_by_slug(slug)
    begin
      return Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags?slug="+slug))
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
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
      results = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + query))
      return JSON.parse results
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def get_category_slug_id_by_name(name)
    begin
      slug_response = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug=#{name}"))
      slug_json = JSON.parse(slug_response)
      slug_id = slug_json[0]["id"]
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def get_posts_by_tag(per_page=PER_PAGE, tag=nil, page=nil, excluded_slug_id=nil)
    begin

      if(tag)
        tag_slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "tags?slug="+tag))
        parsed_tag_slug = JSON.parse(tag_slug)
        tag_slug_id = parsed_tag_slug[0]["id"]
        uri = URI.parse(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=#{per_page}&page=#{page}&tags=#{tag_slug_id}")
      else
        uri = URI.parse(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=#{per_page}&page=#{page}&categories=#{get_category_slug_id_by_name(RECIPES)}")
      end


      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      return response

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

  def get_posts_by_category(per_page=PER_PAGE, category=nil, page=1, excluded_slug_id=nil)
    begin
      if(category)
        category_slug = Net::HTTP.get(URI(Rails.application.secrets.blog_feed_url + "categories?slug="+category))
        parsed_category_slug = JSON.parse(category_slug)
        category_slug_id = parsed_category_slug[0]["id"]
        uri = URI.parse(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=#{per_page}&page=#{page}&categories=#{category_slug_id}")
      else
        uri = URI.parse(Rails.application.secrets.blog_feed_url + "posts/?_embed&per_page=#{per_page}&page=#{page}&categories_exclude=#{excluded_slug_id}")
      end

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      return response

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end


end