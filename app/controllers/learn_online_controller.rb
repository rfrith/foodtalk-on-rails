class LearnOnlineController < ApplicationController
  include Secured, Eligible, LearningModules, ApplicationHelper

  def index
  end

  def show
    lesson_id = "#{params[:curriculum]}/#{params[:module_name]}"
    LearningModules::launch_module(lesson_id, @current_user)
    lesson = LearningModules::find_module(lesson_id)
    @module_url =  "/learn_online/#{I18n.locale}" + lesson[:target_url]
  end

  def launch_module
    respond_to do |format|
      lesson_id = "#{params[:curriculum]}/#{params[:module_name]}"
      lesson = LearningModules::find_module(lesson_id)
      target_url = "/learn_online/#{I18n.locale}" + lesson[:target_url]
      LearningModules::launch_module(lesson[:id], @current_user)
      format.html {
        redirect_to target_url
      }
    end
  end

  def complete_module
    lesson_id = params[:module_name]
    LearningModules::complete_module(lesson_id, @current_user)
    respond_to do |format|
      format.html {
        redirect_to show_dashboard_path
      }
    end
  end

end