class LearnOnlineController < ApplicationController
  include Secured, Eligible, LearningModules, ApplicationHelper

  def index
  end

  def launch_module
    respond_to do |format|
      lesson_id = params[:module_name]
      lesson = LearningModules::find_module(lesson_id)
      target_url = "/learn_online/#{I18n.locale}" + lesson[:target_url]
      format.html {
        if(lesson && target_url)
          @current_user.activity_histories << OnlineLearningHistory.new(name: lesson_id+"#started")
          if(!@current_user.course_enrollments.exists?(name: lesson_id))
            @current_user.course_enrollments << CourseEnrollment.new(name: lesson_id)
          end

          #Ignore introduction video
          #TODO: is there a better way?
          if lesson_id == "FOOD_ETALK[:food_etalk_tutorial]"
            l = @current_user.course_enrollments.where(name: lesson_id, state: :started).take
            if(l)
              l.complete!
            end
          end

          redirect_to target_url
        else
          raise ActionController::RoutingError.new('Lesson Not Found')
        end
      }
    end
  end

  def complete_module
    respond_to do |format|
      lesson_id = params[:module_name]
      lesson = @current_user.course_enrollments.where(name: lesson_id, state: :started).take
      #make sure user has CourseEnrollment record for this lesson
      if(lesson)
        #remove user from course & log history
        lesson.complete!
      elsif @current_user.course_enrollments.where(name: lesson_id, state: :completed).take
          #user completed previously...just show activity
          # TODO: is there a more elegant way?
          @current_user.activity_histories << OnlineLearningHistory.new(name: lesson_id+"#completed")
      else
        raise ActionController::RoutingError.new('Lesson Not Found')
      end
      format.html {
        redirect_to show_dashboard_path
      }
    end
  end

end