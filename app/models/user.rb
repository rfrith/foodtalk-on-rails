class User < ApplicationRecord

  require 'digest/md5'

  has_and_belongs_to_many :racial_identities
  has_and_belongs_to_many :federal_assistances
  has_and_belongs_to_many :recipes

  #TODO: improve this
  ELIGIBLE_ZIP_CODES = [30021,30032,30060,30070,30071,30079,30083,30093,30147,30168,30222,30238,30250,30289,30297,30303,30310,30311,30313,30314,30315,30336,30337,30340,30344,30354,30401,30411,30420,30428,30434,30436,30439,30442,30450,30451,30453,30458,30464,30471,30477,30501,30504,30520,30531,30562,30575,30601,30605,30607,30629,30631,30660,30665,30669,30711,30721,30730,30731,30733,30746,30753,30756,30805,30812,30821,30822,30833,30901,30906,31001,31006,31009,31015,31016,31027,31030,31037,31042,31044,31045,31051,31055,31058,31061,31062,31063,31065,31068,31071,31081,31084,31087,31091,31092,31201,31204,31206,31217,31315,31401,31404,31408,31415,31501,31518,31519,31520,31533,31542,31547,31549,31556,31562,31566,31567,31601,31625,31627,31629,31630,31634,31637,31638,31642,31643,31645,31647,31648,31650,31701,31705,31709,31711,31716,31719,31730,31743,31747,31749,31750,31765,31774,31775,31779,31780,31781,31788,31794,31810,31812,31815,31816,31821,31823,31825,31827,31830,31901,31903,39813,39815,39817,39824,39825,39826,39827,39828,39840,39841,39842,39846,39851,39861,39866,39867,39870,39885]

  enum gender: [:male, :female]

  validates_presence_of :uid
  #TODO: this is a workaround until we can get email from Auth0
  validates_presence_of :first_name, :last_name, :age, :email, :gender, :zip_code, on: :update
  validates_inclusion_of :is_hispanic_or_latino, :in => [true, false], :message => "Please answer the question 'Do you consider yourself Hispanic/Latino?'", on: :update
  validates_numericality_of :age, on: :update
  validates_length_of :zip_code, :is => 5, :message => "Please enter your 5-digit zip code.", on: :update
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, on: :update

  validates :racial_identities, presence: true, on: :update

  def name
    return "#{first_name} #{last_name}"
  end

  def is_eligible?
    return (is_zip_code_eligible? || has_received_federal_assistance?) #TODO: should age factor into eligibility status?
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    #TODO: GET CORRECT AUTH0 HASH KEYS!
    uid = auth_hash["uid"]
    #first_name = auth_hash['extra']['raw_info']['given_name']
    #last_name = auth_hash['extra']['raw_info']['family_name']

    first_name = auth_hash['info']['name'].split(" ")[0..-2].join(" ")
    last_name = auth_hash['info']['name'].split(" ").last
    email = auth_hash['info']['email']

    user = self.find_or_create_by(uid: uid) do |user|
      user.first_name = first_name
      user.last_name = last_name
      user.email = email
    end

    return user

  end

  def email_as_md5_hash
    if(self.email)
      Digest::MD5.hexdigest(self.email.downcase)
    end
  end

  private

  def is_zip_code_eligible?
    return ELIGIBLE_ZIP_CODES.include?(zip_code)
  end

  def has_received_federal_assistance?
    return (federal_assistances.size >= 1)
  end


end