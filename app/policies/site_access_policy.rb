class SiteAccessPolicy < Struct.new(:user, :site_access)

  attr_reader :user

  def initialize(user, site_access)
    @user = user
  end

  def view_spanish_content?
    case user.host_name
    when "caresource.foodtalk.org"
      true
    else
      false
    end
  end

  def view_food_glossary?
    #TODO: uncommment me after testing!
    #return true if user.admin? or user.super_admin?
    determine_access_rights_by_host_name
  end

  def view_default_index?
    #TODO: uncommment me after testing!
    #return true if user.admin? or user.super_admin?
    determine_access_rights_by_host_name
  end

  def view_blog?
    #TODO: uncommment me after testing!
    #return true if user.admin? or user.super_admin?
    #TODO: implement site access by group attributes instead of hardcoding host name!
    determine_access_rights_by_host_name
  end

  def view_recipes?
    #TODO: uncommment me after testing!
    #return true if user.admin? or user.super_admin?
    determine_access_rights_by_host_name
  end

  def view_videos?
    #TODO: uncommment me after testing!
    #return true if user.admin? or user.super_admin?
    determine_access_rights_by_host_name
  end

  def view_attend_class?
    determine_access_rights_by_host_name
  end

  def view_gis_resources?
    determine_access_rights_by_host_name
  end

  def subscribe_to_newsletter?
    determine_access_rights_by_host_name
  end

  def view_elearning?
    user.is_eligible?
  end


  private

  def determine_access_rights_by_host_name
    case user.host_name
    when "caresource.foodtalk.org"
      false
    else
      true
    end
  end

end