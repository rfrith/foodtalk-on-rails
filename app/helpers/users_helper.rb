module UsersHelper

  def get_group_links(user)
    if !user.groups.empty?
      user.groups.map{ |g| link_to(g.title, find_by_group_path(g.name))}.join(" | ").html_safe
    else
      link_to Group::FOODTALK_USERS, find_by_group_path(Group::FOODTALK_USERS)
    end
  end

end
