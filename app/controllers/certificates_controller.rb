class CertificatesController < ApplicationController

  include Secured, CurriculumHelper

  require 'rmagick'
  include Magick
  require 'base64'

  def show
    #https://stackoverflow.com/a/7625116
    img = ImageList.new
    img_url = open(view_context.asset_url('FoodEtalkCompletionCertificate.png'))
    img.from_blob(img_url.read)
    txt = Draw.new
    img.annotate(txt, 0,0,0,-50, current_user.name){
      txt.gravity = Magick::CenterGravity
      txt.font_family = 'helvetica'
      txt.pointsize = 25
      txt.font_weight = Magick::BoldWeight
    }

    img.annotate(txt, 0,0,0,40, curriculum_completion_date(current_user, LearningModules::FOOD_ETALK).strftime("%B %d, %Y")){
      txt.gravity = Magick::CenterGravity
      txt.font_family = 'helvetica'
      txt.pointsize = 25
      txt.font_weight = Magick::BoldWeight
    }

    img.format = 'png'
    #to send directly to browser, bypassing view
    #send_data img.to_blob, stream: false, filename: 'certificate.png', type: 'image/png', disposition: 'inline'
    img_data = Base64.encode64(img.to_blob).gsub(/\n/, "")
    @certificate = img_data
  end
end