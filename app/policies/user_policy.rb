class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
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
