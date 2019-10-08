class NotificationPolicy < Struct.new(:user, :notification)

  attr_reader :user

  def initialize(user, notification)
    @user = user
  end

  def create?
    return user.super_admin?
  end

end