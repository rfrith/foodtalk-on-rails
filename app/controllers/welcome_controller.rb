class WelcomeController < ApplicationController
  def index
    #TODO: put me in ENV
    url = 'http://blog.foodtalk.org/blog/wp-json/wp/v2/posts/?_embed'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @blogs = JSON.parse(response)
  end
end
