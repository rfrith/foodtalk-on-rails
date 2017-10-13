class NewsletterSignUpController < ApplicationController
  def create
    @email = params[:email]
    logger.debug "params: #{params}"
    logger.debug "@email: #{@email}"

    respond_to do |format|


      render plain: params[:article].inspect

      #format.html { render text: 'Success!' }
      #format.js { render text: 'Success!' }
      #format.json { render json: @email, status: :signed_up, location: @email }
    end
  end
end