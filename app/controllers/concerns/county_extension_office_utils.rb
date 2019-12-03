require "#{Rails.root}/app/helpers/curriculum_helper"
include CurriculumHelper

module CountyExtensionOfficeUtils
  extend ActiveSupport::Concern

  def get_curriculum_completion_in_date_range_by_zip_code(date_range, zip_codes)
    completions = []

    zip_codes.each do |zip_code|
      zip = zip_code.zip

      users = User.where(zip_code: zip)

      if(!users.empty?)
        completed_users = find_users_have_completed_program(users: users, date_range: date_range)
        completions << {zip => User.where(id: completed_users.map(&:id))} unless completed_users.empty?
      end

    end
    return completions
  end

end
