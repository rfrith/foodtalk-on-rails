class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin? || user.admin?
        scope.all
      elsif user.group_admin?
        user.users
      end
    end
  end

  def show?
    user.is_admin?
  end

  def update?
    !user.test_user?
  end

  def update_user_groups?
    user.super_admin? || user.admin?
  end

  def update_user_roles?
    user.super_admin? || user.admin?
  end


  def launch_module?
    !user.test_user?
  end

  def complete_module?
    !user.test_user?
  end



  def find_user_by_criteria?
    user.is_admin?
  end

  def find_by_month?
    user.is_admin?
  end

  def find_by_month_and_group?
    user.is_admin?
  end

  def find_by_group?
    user.is_admin?
  end

  def find_by_eligibility?
    user.is_admin?
  end

  def find_by_eligibility_and_group?
    user.is_admin?
  end

  def find_by_started_and_or_completed_curricula?
    user.is_admin?
  end

  def find_by_started_and_or_completed_curricula_by_group?
    user.is_admin?
  end

end
