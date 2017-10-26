class User < ApplicationRecord

  has_and_belongs_to_many :racial_identities
  has_and_belongs_to_many :federal_assistances

  #TODO: improve this
  ELIGIBLE_ZIP_CODES = [30021,30032,30060,30070,30071,30079,30093,30117,30147,30168,30177,30230,30250,30251,30297,30303,30310,30311,30313,30314,30315,30318,30322,30336,30337,30340,30354,30401,30429,30434,30436,30439,30442,30445,30446,30449,30450,30453,30458,30464,30477,30501,30513,30531,30560,30562,30601,30602,30605,30607,30631,30664,30665,30668,30721,30730,30731,30734,30753,30756,30757,30805,30812,30821,30822,30828,30830,30833,30901,30904,30905,30906,31006,31007,31009,31011,31015,31027,31030,31033,31037,31041,31042,31044,31045,31051,31054,31055,31058,31062,31063,31068,31071,31076,31078,31081,31084,31085,31087,31092,31093,31201,31204,31206,31217,31301,31315,31401,31404,31408,31415,31519,31520,31533,31542,31544,31547,31549,31555,31556,31566,31567,31568,31601,31623,31625,31629,31630,31637,31638,31642,31645,31647,31648,31650,31701,31705,31711,31714,31719,31720,31722,31730,31743,31747,31750,31765,31771,31775,31779,31780,31787,31789,31794,31810,31812,31815,31816,31825,31827,31830,31901,31903,39813,39815,39817,39824,39825,39827,39828,39840,39841,39842,39845,39846,39851,39854,39861,39866,39867,39870,39877,39885,39886]

  enum gender: [:male, :female]

  validates_presence_of :uid
  #TODO: this is a workaround until we can get email from Auth0
  validates_presence_of :first_name, :last_name, :age, :email, :gender, :zip_code, on: :update
  validates_inclusion_of :is_hispanic_or_latino, :in => [true, false], :message => "Please answer the question 'Do you consider yourself Hispanic/Latino?'", on: :update
  validates_numericality_of :age, on: :update
  validates_length_of :zip_code, :is => 5, :message => "Please enter your 5-digit zip code.", on: :update
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, on: :update


  def name
    return "#{first_name} #{last_name}"
  end

  def is_zip_code_eligible?
    return ELIGIBLE_ZIP_CODES.include?(self.zip_code)
  end

  def is_eligible?
    return self.is_zip_code_eligible? || false
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    #TODO: GET CORRECT AUTH0 HASH KEYS!
    uid = auth_hash["uid"]
    first_name = auth_hash['extra']['raw_info']['given_name']
    last_name = auth_hash['extra']['raw_info']['family_name']
    email = auth_hash['email']

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