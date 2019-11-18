class CertificatesController < ApplicationController

  include Secured, CurriculumHelper

  require 'rmagick'
  include Magick
  require 'base64'

  def show

    begin
      image_name = "CompletionCertificate_#{I18n.locale}.png"
      food_etalk_completion_date = curriculum_completion_date(@current_user, LearningModules::FOOD_ETALK)
      better_u_completion_date = curriculum_completion_date(@current_user, LearningModules::BETTER_U)
      completion_date = food_etalk_completion_date >= better_u_completion_date ? food_etalk_completion_date : better_u_completion_date
      @certificates = [create_certificate(image_name, completion_date)] #view expects array
    rescue => e
      logger.error "An error occurred: #{e.inspect}"
    end

  end


  private

  def create_certificate(image_name, completion_date)

    begin
      #https://stackoverflow.com/a/7625116
      img = ImageList.new
      img_url = open(view_context.asset_url(image_name))
      img.from_blob(img_url.read)
      txt = Draw.new
      img.annotate(txt, 0,0,0,20, @current_user.name){
        txt.gravity = Magick::CenterGravity
        txt.font_family = 'helvetica'
        txt.pointsize = 25
        txt.font_weight = Magick::BoldWeight
      }

      img.annotate(txt, 0,0,0,130, completion_date){
        txt.gravity = Magick::CenterGravity
        txt.font_family = 'helvetica'
        txt.pointsize = 25
        txt.font_weight = Magick::BoldWeight
      }

      img.format = 'png'
      #to send directly to browser, bypassing view
      #send_data img.to_blob, stream: false, filename: 'certificate.png', type: 'image/png', disposition: 'inline'
      img_data = Base64.encode64(img.to_blob).gsub(/\n/, "")

    rescue => e
      logger.error "An error occurred: #{e.inspect}"
      logger.warn "Falling back to render plain certificate: #{image_name}"
      #fallback to plain image if any ImageMagick/GhostScript failures occur
      img = open(view_context.asset_url(image_name))
      return Base64.encode64 img.read
    end

    return img_data

  end

end