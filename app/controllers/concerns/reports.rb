require 'csv'


module Reports
  extend ActiveSupport::Concern

  TYPES ||= [:admin, :group_admin]

  def generate_report_as_csv(report_type, users, groups, eligibility_status=nil)

    raise Exception.new "Invalid report_type!" if !TYPES.include?(report_type)

    uniq_groups = groups.order('name ASC').uniq #remove any duplicates

    column_names = []

    racial_identities = RacialIdentity.all
    federal_assistances = FederalAssistance.all
    better_u_modules = LearningModules::BETTER_U
    food_etalk_modules = LearningModules::FOOD_ETALK
    video_surveys = VideoSurveys::MAP_VIDEOS_TO_SURVEYS


    csv_string = CSV.generate do |csv|

      column_names = get_column_headers(report_type, uniq_groups, racial_identities, federal_assistances, better_u_modules, food_etalk_modules, video_surveys)

      csv << column_names

      users.each do |u|

        values = []

        #skip users based on presence of eligibility_status argument
        next if !eligibility_status.nil? and u.is_eligible? != eligibility_status #must check for .nil? because .blank? will return true for false value

        case report_type
        when :admin
          values << (u.admin? ? 1 : 0)
          values << (u.group_admin? ? 1 : 0)
          values << (u.test_user? ? 1 : 0)
        end

        uniq_groups.each do |g|
          values << (u.groups.include?(g) ? 1 : 0)
        end

        values += [u.created_at.to_s, u.uid, (u.is_eligible? ? 1 : 0), u.first_name, u.last_name, u.email, u.gender, u.age, u.zip_code, u.is_hispanic_or_latino]

        racial_identities.each do |ri|
          values << ( u.racial_identities.exists?(ri.id) ? 1 : 0)
        end

        federal_assistances.each do |fa|
          values << ( u.federal_assistances.exists?(fa.id) ? 1 : 0)
        end

        better_u_modules.each do |m|
          started = (u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#started").size > 0)
          values << (started ? 1 : 0)
          completed = (u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#completed").size > 0)
          values << (completed ? 1 : 0)
        end

        food_etalk_modules.each do |m|
          started = (u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#started").size > 0)
          values << (started ? 1 : 0)
          completed = (u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#completed").size > 0)
          values << (completed ? 1 : 0)
        end

        video_surveys.each do |vs|
          started = (u.survey_histories.where("name LIKE ?", "%#{vs[:survey_args][:origin]}%#started").size > 0)
          values << (started ? 1 : 0)
          completed = (u.survey_histories.where("name LIKE ?", "%#{vs[:survey_args][:origin]}%#completed").size > 0)
          values << (completed ? 1 : 0)
        end

        csv << values

      end

    end

    return csv_string

  end


  private

  def get_column_headers(report_type, groups, racial_identities, federal_assistances, better_u_modules, food_etalk_modules, video_surveys)

    headers = []

    case report_type
    when :admin
      headers << "Administrator"
      headers << "Group Administrator"
      headers << "Test User"
    end

    groups.each do |g|
      headers << g.name
    end

    headers += ["signup_date", "uid", "is_eligible", "first_name", "last_name", "email", "gender", "age", "zip_code", "is_hispanic_or_latino"]

    racial_identities.each do |ri|
      headers << ri.name.parameterize.underscore
    end

    federal_assistances.each do |fa|
      headers << fa.name.parameterize.underscore
    end

    better_u_modules.each do |m|
      headers << m[:id].gsub("/", "_").gsub("#", "_") + "_started"
      headers << m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
    end

    food_etalk_modules.each do |m|
      headers << m[:id].gsub("/", "_").gsub("#", "_") + "_started"
      headers << m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
    end

    video_surveys.each do |vs|
      headers << vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_started"
      headers << vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_completed"
    end

    return headers
  end

end