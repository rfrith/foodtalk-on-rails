class User < ApplicationRecord

  require 'digest/md5'

  has_and_belongs_to_many :racial_identities
  has_and_belongs_to_many :federal_assistances
  has_and_belongs_to_many :recipes
  has_and_belongs_to_many :groups
  has_many :activity_histories, dependent: :destroy
  has_many :online_learning_histories, dependent: :destroy
  has_many :survey_histories, dependent: :destroy
  has_many :course_enrollments, dependent: :destroy


  #TODO: improve this
  ELIGIBLE_ZIP_CODES = [31821, 31823, 31824, 31825, 31827, 31830, 31832, 31836, 31901, 31903, 31906, 30238, 30250, 30260, 30274, 30275, 30289, 30297, 30303, 30305, 30306, 30307, 30308, 30310, 30311, 30312, 30313, 30314, 30315, 30316, 30317, 30319, 30322, 30326, 30329, 30332, 30334, 30336, 30337, 30340, 30341, 30344, 30345, 30354, 30401, 30410, 30411, 30412, 30413, 30415, 30417, 30420, 30421, 30423, 30425, 30428, 30429, 30434, 30436, 30438, 30439, 30442, 30445, 30448, 30449, 30450, 30451, 30452, 30453, 30454, 30455, 30457, 30458, 30460, 30461, 30464, 30467, 30470, 30471, 30473, 30474, 30475, 30477, 30501, 30504, 30520, 31512, 31518, 31519, 31520, 31401, 31784, 31788, 31790, 31792, 31793, 31794, 31798, 31404, 31408, 31810, 31812, 31814, 31815, 31816, 31415, 31501, 30531, 30562, 30566, 31315, 30575, 30601, 30602, 30605, 30607, 30609, 30629, 30631, 30660, 30664, 30665, 30669, 30673, 30711, 30721, 30730, 30731, 30733, 30746, 30751, 30753, 30756, 30803, 30805, 30807, 30812, 30818, 30821, 30822, 30833, 30901, 30903, 30906, 30912, 31001, 31002, 31006, 31007, 31009, 31011, 31015, 31016, 31018, 31019, 31021, 31023, 31027, 31030, 31035, 31037, 31039, 31041, 31042, 31044, 31045, 31049, 31051, 31055, 31057, 31058, 31060, 31061, 31062, 31063, 31065, 31067, 31068, 31070, 31071, 31072, 31075, 31076, 31077, 31079, 31081, 31082, 31083, 31084, 31087, 31089, 31091, 31092, 31094, 31096, 31201, 31204, 31206, 30046, 31207, 31213, 31217, 30060, 30070, 30071, 30072, 30076, 30079, 30083, 30088, 30093, 30118, 30147, 30168, 30222, 30002, 30009, 30021, 30030, 30032, 30033, 30034, 30035, 39813, 39815, 39817, 39819, 39823, 39824, 39825, 39826, 39827, 39828, 39834, 39836, 39837, 39840, 39841, 39842, 39845, 39846, 39851, 39854, 39859, 39861, 39862, 39866, 39867, 39870, 39877, 39885, 39886, 39897, 31533, 31535, 31542, 31544, 31545, 31546, 31547, 31549, 31550, 31552, 31555, 31556, 31560, 31562, 31563, 31566, 31567, 31601, 31620, 31622, 31623, 31624, 31625, 31627, 31629, 31630, 31634, 31637, 31638, 31642, 31643, 31645, 31647, 31648, 31650, 31698, 31701, 31705, 31709, 31711, 31712, 31716, 31719, 31722, 31730, 31733, 31735, 31738, 31743, 31747, 31749, 31750, 31756, 31757, 31765, 31768, 31773, 31774, 31775, 31779, 31780, 31781, 31783]

  enum gender: [:male, :female]


  validates_presence_of :uid
  #TODO: this is a workaround until we can get email from Auth0
  validates_presence_of :first_name, :last_name, :age, :email, :gender, :zip_code
  validates_inclusion_of :is_hispanic_or_latino, :in => [true, false], :message => "Please answer the question 'Do you consider yourself Hispanic/Latino?'"
  validates_numericality_of :age
  validates_length_of :zip_code, :is => 5, :message => "must be at least 5-digits."
  validates_uniqueness_of :email
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :racial_identities, presence: true

  def name
    return "#{first_name} #{last_name}"
  end

  def is_eligible?
    return (is_zip_code_eligible? || has_received_federal_assistance?) #TODO: should age factor into eligibility status?
  end

  def self.find_or_initialize_from_auth_hash(auth_hash)

    #TODO: CHECK WE'RE GETTING CORRECT AUTH0 HASH KEYS!
    #first_name = auth_hash['extra']['raw_info']['given_name']
    #last_name = auth_hash['extra']['raw_info']['family_name']
    if(auth_hash)
      uid = auth_hash['uid']
      first_name = auth_hash['first_name']
      last_name = auth_hash['last_name']
      email = auth_hash['email']
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

  private

  def is_zip_code_eligible?
    return ELIGIBLE_ZIP_CODES.include?(zip_code)
  end

  def has_received_federal_assistance?
    return (federal_assistances.size >= 1)
  end


end