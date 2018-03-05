class BlogsController < ApplicationController

  skip_before_action :check_consent
  skip_before_action :check_personal_info

  def index
  end

  def show
  end

  def demo_blog1
  end

  def demo_blog2
  end

  def demo_blog3
  end

end