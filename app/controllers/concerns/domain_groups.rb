module DomainGroups
  extend ActiveSupport::Concern

  MAP_USERS_TO_DOMAIN_GROUPS = [
      {
          group_name: "mercy-health-center"
      }
  ]

  def user_belongs_to_domain_group(user)
    MAP_USERS_TO_DOMAIN_GROUPS.each do |entry|
      return user.groups.exists?(name: entry[:group_name])
    end
  end

  def get_domain_group_logo(host)
    MAP_USERS_TO_DOMAIN_GROUPS.each do |entry|
      group = Group.find_by(name: entry[:group_name])
      if group && (group.domain == host)
        return group.logo
      end
    end
    return nil
  end

  def get_domain_group_icon(host)
    MAP_USERS_TO_DOMAIN_GROUPS.each do |entry|
      group = Group.find_by(name: entry[:group_name])
      if group && (group.domain == host)
        return group.icon
      end
    end
    return nil
  end

  def add_user_to_domain_group(user, domain)
    group = Group.find_by(domain: domain)
    user.groups << group unless group.nil?
  end

  module_function :user_belongs_to_domain_group, :get_domain_group_logo, :get_domain_group_icon

end