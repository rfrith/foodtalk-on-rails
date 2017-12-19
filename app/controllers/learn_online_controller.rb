class LearnOnlineController < ApplicationController
  include Secured, LearningModules, ApplicationHelper

  def index
  end

  def launch_module
    respond_to do |format|
      lesson_id = params[:module_name]
      if(correct_syntax?(lesson_id))
        lesson = eval lesson_id
        if(lesson && lesson[:target_url])
          target_url = lesson[:target_url].sub("email=", "email=#{current_user.email}").sub("uid=", "uid=#{current_user.uid}")
        end
      end
      format.html {
        if(lesson && target_url)
          current_user.activity_histories << OnlineLearningHistory.new(name: lesson_id)
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

end