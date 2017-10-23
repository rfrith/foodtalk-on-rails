class User < ApplicationRecord

  enum gender: [:male, :female]

  validates_presence_of :first_name, :last_name, :age, :email #, :uid
  #TODO: this is a workaround until we can get email from Auth0
  validates_presence_of :email, on: :update, if: Proc.new { |a| !a.email.blank? }

  def name
    return "#{first_name} #{last_name}"
  end

  def self.find_or_create_from_auth_hash(auth_hash)

    uid = auth_hash["extra"]["raw_info"]["sub"]
    first_name = auth_hash["info"]["first_name"]
    last_name = auth_hash["info"]["last_name"]
    email = auth_hash["info"]["email"]

    puts "uid: " + uid if uid
    puts "first_name: " + first_name if first_name
    puts "last_name: " + last_name if last_name
    puts "email: " + email if email

    user = self.find_or_create_by(uid: uid) do |user|
      user.first_name = first_name
      user.last_name = last_name
      user.email = email
    end

    return user

  end

end