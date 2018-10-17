require 'csv'

module Reports
  extend ActiveSupport::Concern

  TYPES = [:activity]

  def generate_report_as_csv(users, eligible=nil)

    groups = []

    column_names = []

    csv_string = CSV.generate do |csv|

      #Group.where("name != '#{Group::ADMIN}'").each do |g|
      Group.order('name ASC').each do |g|
        groups << g
        column_names << g.name
      end

      column_names += ["signup_date", "uid", "is_eligible", "first_name", "last_name", "email", "gender", "age", "zip_code", "is_hispanic_or_latino"]

      RacialIdentity.all.each do |ri|
        column_names << ri.name.parameterize.underscore
      end

      FederalAssistance.all.each do |fa|
        column_names << fa.name.parameterize.underscore
      end

      LearningModules::BETTER_U.each do |m|
        column_names << m[:id].gsub("/", "_").gsub("#", "_") + "_started"
        column_names << m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
      end

      LearningModules::FOOD_ETALK.each do |m|
        column_names << m[:id].gsub("/", "_").gsub("#", "_") + "_started"
        column_names << m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
      end

      VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each do |vs|
        column_names << vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_started"
        column_names << vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_completed"
      end

      csv << column_names

      users.each do |u|

        values = []

        #skip users based on presence of eligible argument
        next if !eligible.nil? and u.is_eligible? != eligible #must check for .nil? because .blank? will return true for false value

        groups.each do |g|

          user_groups = u.groups

          if user_groups.include?(g)
            values << 1
          else
            values << 0
          end
        end

        values += [u.created_at, u.uid, (u.is_eligible? ? 1 : 0), u.first_name, u.last_name, u.email, u.gender, u.age, u.zip_code, u.is_hispanic_or_latino]

        RacialIdentity.all.each do |ri|
          if u.racial_identities.exists?(ri.id)
            values << 1
          else
            values << 0
          end
        end

        FederalAssistance.all.each do |fa|
          if u.federal_assistances.exists?(fa.id)
            values << 1
          else
            values << 0
          end
        end

        LearningModules::BETTER_U.each do |m|
          if u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#started").size > 0
            values << 1
          else
            values << 0
          end

          if u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#completed").size > 0
            values << 1
          else
            values << 0
          end
        end

        LearningModules::FOOD_ETALK.each do |m|
          if u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#started").size > 0
            values << 1
          else
            values << 0
          end

          if u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#completed").size > 0
            values << 1
          else
            values << 0
          end
        end

        VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each do |vs|
          if u.survey_histories.where("name LIKE ?", "%#{vs[:survey_args][:origin]}%#started").size > 0
            values << 1
          else
            values << 0
          end

          if u.online_learning_histories.where("name LIKE ?", "%#{vs[:survey_args][:origin]}%#completed").size > 0
            values << 1
          else
            values << 0
          end
        end

        csv << values

      end

    end

    return csv_string

  end

end