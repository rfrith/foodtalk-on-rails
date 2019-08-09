class WordpressPagesController < ApplicationController

  include WordpressUtils, WordpressHelper

  def show
    begin
      @show_nav = params[:show_nav]
      @slug = params[:slug]
      page = get_cached_api_response("wp-page-#{@slug}", URI(Rails.application.secrets.blog_feed_url + "pages?_embed&slug=#{@slug}")).body
      parsed_page = JSON.parse(page)
      @page_content = parsed_page[0]["content"]["rendered"]
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end
  end

end
