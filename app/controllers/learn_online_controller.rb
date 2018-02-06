class LearnOnlineController < ApplicationController
  include Secured, Eligible, LearningModules, ApplicationHelper

  before_action :check_eligibility

  def index
  end

  def launch_module
    respond_to do |format|
      lesson_id = params[:module_name]
      lesson = LearningModules::find_module(lesson_id)
      target_url = lesson[:target_url]
      format.html {
        if(lesson && target_url)
          current_user.activity_histories << OnlineLearningHistory.new(name: lesson_id+"#started")
          if(!current_user.course_enrollments.exists?(name: lesson_id))
            current_user.course_enrollments << CourseEnrollment.new(name: lesson_id)
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
      lesson = current_user.course_enrollments.where(name: lesson_id, state: :started).take
      #make sure user has CourseEnrollment record for this lesson
      if(lesson)
        #remove user from course & log history
        lesson.complete!
      else
        raise ActionController::RoutingError.new('Lesson Not Found')
      end
      format.html {
        redirect_to dashboard_show_path
      }
    end
  end

end