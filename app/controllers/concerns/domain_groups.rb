module DomainGroups
  extend ActiveSupport::Concern

  DOMAIN_GROUPS = [
      {
          id: :mhc,
          group_name: "mercy-health-center"
      },
      {
          id: :hhip,
          group_name: "hancock-health-improvement-partnership"
      }
  ]

  def self.find_domain_group(id)
    DOMAIN_GROUPS.each do |dg|
      if (dg[:id] == id)
        return dg
      end
    end
    return nil
  end

  def user_belongs_to_domain_group(user, group_id)
    return user.groups.exists?(name: group_id)
  end


  def get_domain_group_logo(host)
    DOMAIN_GROUPS.each do |entry|
      group = Group.find_by(name: entry[:group_name])
      if group && (group.domain == host)
        return group.logo
      end
    end
    return nil
  end

  def get_domain_group_icon(host)
    DOMAIN_GROUPS.each do |entry|
      group = Group.find_by(name: entry[:group_name])
      if group && (group.domain == host)
        return group.icon
      end
    end
    return nil
  end

  def add_user_to_domain_group(user, domain)
    group = Group.find_by(domain: domain)
    user.groups << group unless group.nil? or user.groups.include?(group)
  end

  module_function :user_belongs_to_domain_group, :get_domain_group_logo, :get_domain_group_icon

end