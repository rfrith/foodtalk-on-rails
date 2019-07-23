class CertificatesController < ApplicationController

  include Secured, CurriculumHelper

  require 'rmagick'
  include Magick
  require 'base64'

  def show

    begin
      curriculum = params[:id]

      case params[:id]
      when LearningModules.module_name(:FOOD_ETALK)
        image_name = 'FoodEtalkCompletionCertificate.png'
        completion_date = curriculum_completion_date(@current_user, LearningModules::FOOD_ETALK)
        @certificates = [create_certificate(image_name, completion_date)]

      when LearningModules.module_name(:BETTER_U)
        image_name = 'BetterUCompletionCertificate.png'
        completion_date = curriculum_completion_date(@current_user, LearningModules::BETTER_U)
        @certificates = [create_certificate(image_name, completion_date)]

      else
        #show all obtained certificates
        food_etalk_image_name = 'FoodEtalkCompletionCertificate.png'
        food_etalk_completion_date = curriculum_completion_date(@current_user, LearningModules::FOOD_ETALK)

        better_u_image_name = 'BetterUCompletionCertificate.png'
        better_u_completion_date = curriculum_completion_date(@current_user, LearningModules::BETTER_U)

        @certificates = [create_certificate(better_u_image_name, better_u_completion_date), create_certificate(food_etalk_image_name, food_etalk_completion_date)]
      end

    rescue => e
      add_notification :error, t(:error), "#{t("error_occurred")}: #{e.to_s}", false
    end

  end


  private

  def create_certificate(image_name, completion_date)
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

    return img_data
  end




end