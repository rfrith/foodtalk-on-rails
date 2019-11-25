class User < ApplicationRecord

  require 'digest/md5'

  has_and_belongs_to_many :racial_identities
  has_and_belongs_to_many :federal_assistances
  has_and_belongs_to_many :groups do
    def members
      group_members = []
      proxy_association.owner.groups.collect {|group| group.users }.each do |users|
        group_members << users
      end
      group_members.flatten!
      return User.where(id: group_members.map(&:id))
    end
  end

  has_many :activity_histories, dependent: :destroy
  has_many :online_learning_histories, dependent: :destroy
  has_many :survey_histories, dependent: :destroy
  has_many :course_enrollments, dependent: :destroy
  has_many :users, through: :groups

  has_many :playlists
  has_many :playlist_items, through: :playlists

  #regular Foodtalk users; non-admins & no group affiliation
  scope :not_in_group, ->  {left_outer_joins(:groups).where(groups: {id: nil})}
  scope :in_group, -> (name) {left_outer_joins(:groups).where(groups: {name: name})}

  scope :search_by_full_name, ->(query) { where( "LOWER(first_name) || ' ' || LOWER(last_name) LIKE LOWER(?)", "%#{query}%")}

  scope :search_by_email, ->(query) { where("LOWER(email) LIKE LOWER(?)", "%#{query}%") }

  scope :all_eligible, ->{ where(eligible: true) }
  scope :all_ineligible, ->{ where(eligible: false) }

  enum gender: {male: 0, female: 1}

  #WARNING: add to, but do not change existing values
  enum role: { user: 0, group_admin: 1, admin: 2, test_user: 3, super_admin: 4, group_contact: 5}


  validates_presence_of :uid, :first_name, :last_name, :age, :email, :gender, :zip_code
  validates_inclusion_of :is_hispanic_or_latino, :in => [true, false], :message => "Please answer the question 'Do you consider yourself Hispanic/Latino?'"
  validates_numericality_of :age
  validates_length_of :zip_code, :is => 5, :message => "must be at least 5-digits."
  validates_uniqueness_of :email, :uid
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :racial_identities, presence: true

  attr_accessor :host_name #for pundit view access policies by group/domain assignment


  after_initialize do
    if self.new_record?
      self.role ||= :user
    end
  end

  def is_admin?
    return self.super_admin? || self.admin? || self.group_admin?
  end

  def name
    return "#{first_name} #{last_name}"
  end

  def is_eligible?
    return (self.eligible || determine_eligibility)
  end

  def is_ineligible?
    return !is_eligible?
  end

  def seed_eligibile!
    self.eligible ||= self.update_eligibile!
  end

  def update_eligibile!
    self.eligible = self.determine_eligibility
    self.save!
  end

  def determine_eligibility
    (is_zip_code_eligible? || has_received_federal_assistance? || is_admin?) #TODO: should age factor into eligibility status?
  end

  def group_names
    names = []
    if !groups.empty?
      groups.each do |g|
        names << (g.title ? g.title.titleize : g.name.titleize)
      end
    else
      names << Group::FOODTALK_USERS.titleize
    end
    return names
  end

  def racial_identities_names
    names = []
    racial_identities.each do |ri|
      names << ri.name
    end
    return !names.empty? ? names : ['None']
  end

  def federal_assistances_names
    names = []
    federal_assistances.each do |ga|
      names << ga.name
    end
    return !names.empty? ? names : ['None']
  end

  def self.find_or_initialize_from_auth_hash(auth_hash)
    if(!auth_hash.blank?)
      auth_hash.symbolize_keys! #must do this because the hash sometimes uses symbols and sometimes uses strings
      uid = auth_hash[:uid]
      first_name = auth_hash[:first_name]
      last_name = auth_hash[:last_name]
      email = auth_hash[:email]
    end

    user = self.find_or_initialize_by(uid: uid) do |user|
      user.first_name = first_name
      user.last_name = last_name unless (last_name == email) # Auth0 inserts email as user's last name for some reason if they sign up using email address
      user.email = email
    end

    return user
  end

  def email_as_md5_hash
    if(self.email)
      Digest::MD5.hexdigest(self.email.downcase)
    end
  end

  def get_county_extension_offices
    zips = ZipCode.where(zip: zip_code)
    return CountyExtensionOffice.includes(:zip_codes).where("zip_codes.id": zips.each{|zip| zip.id})
  end


  private

  def is_zip_code_eligible?
    return false if zip_code.nil?
    zip = ZipCode.where(zip: zip_code).first

    return zip ? zip.eligible : false

  end

  def has_received_federal_assistance?
    return (federal_assistances.size > 0)
  end

end